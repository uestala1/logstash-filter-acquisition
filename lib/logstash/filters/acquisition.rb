# encoding: utf-8
require "logstash/filters/base"
require "logstash/namespace"
require "json"
require "uri"

# This  filter will replace the contents of the default 
# message field with whatever you specify in the configuration.
#
# It is only intended to be used as an .
class LogStash::Filters::Acquisition < LogStash::Filters::Base

  # Setting the config_name here is required. This is how you
  # configure this filter from your Logstash config.
  #
  # filter {
  #   {
  #     acquisition {
  #       wse => "Search Egine JSON Path"
  #       rrss => "RRSS JSON Path"
  #       referer => "My HTTP Referer"
  #       destination => "My HTTP Destination"
  #   }
  # }
  #
  config_name "acquisition"

  # RRSS & Web Search Engines JSON
  config :wse, :validate => :string, :default => nil
  config :rrss, :validate => :string, :default => nil
  
  # HTTP Referer
  config :referer, :validate => :string, :default => ""

  # HTTP Destination
  config :destination, :validate => :string, :default => ""
  

  public
  def register
    # Add instance variables 
  end # def register

  public
  def filter(event)

    referer = event.get(@referer)
    destination = event.get(@destination)

    if @wse.nil?
      @wse = ::File.expand_path('../../../../json/wse.json', __FILE__)
    end

    file = ::File.read(@wse)
    wse = JSON.parse(file)["data"]

    if @rrss.nil?
      @rrss = ::File.expand_path('../../../../json/rrss.json', __FILE__)
    end

    file = ::File.read(@rrss)
    rrss = JSON.parse(file)["data"]

    if self.get_domain(referer) != self.get_domain(destination)
      if referer.to_s.strip.empty? && self.get_domain(referer).to_s.strip.empty?
        unless self.get_param(destination, "utm_campaign").strip.empty?
          self.campaign(event, destination)
        else
          self.direct(event)
        end
      elsif !referer.to_s.strip.empty? && !self.get_domain(referer).to_s.strip.empty?
        seo_source = self.get_wse(wse, referer)
        social_source = self.get_rrss(rrss, referer)
        if seo_source != false
          self.seo(event, referer, seo_source)
        elsif social_source != false
          self.social(event, social_source)
        else
          self.referral(event, referer)
        end
      end
    end

    # filter_matched should go in the last line of our successful code
    filter_matched(event)
  end # def filter

  public
  def get_param(url, param_name)
    param_value = url.partition(param_name + '=').last
    if param_value
      param_value = param_value.partition('&')[0]
      return param_value.to_s
    else
      return ""
    end
  end

  public
  def get_wse(json, referer)

    json.each do |child|
      if referer.include? ("." + child["name"] + ".")
        return child["name"]
      end
    end

    return false
        
  end

  public
  def get_rrss(json, referer)

    json.each do |child|
      if referer.scan(Regexp.new(child["regex"])).size > 0
        return child["name"]
      end
    end

    return false
        
  end

  public
  def get_domain(url)
    if !url.to_s.strip.empty?
      url = "http://#{url}" if URI.parse(URI.encode(url.strip)).scheme.nil?
      url = URI.parse(URI.encode(url.strip))
      if url.scheme && !url.host.nil?
        host = url.host.downcase
        host.start_with?('www.') ? host[4..-1] : host
        return host
      end
    end
    
    return ""
  end

  public
  def seo(event, referer, source)
    event.set("[page][acquisition][tipo]", 'seo')
    event.set("[page][acquisition][seo_keyword]", self.get_param(referer, "q"))
    event.set("[page][acquisition][seo_source]", source)
  end

  public
  def referral(event, referer)
    event.set("[page][acquisition][tipo]", 'referral')
    event.set("[page][acquisition][referral_domain]", self.get_domain(referer))
  end

  public
  def social(event, source)
    event.set("[page][acquisition][tipo]", 'social')
    event.set("[page][acquisition][social_source]", source)
  end

  public
  def campaign(event, destination)
    event.set("[page][acquisition][tipo]", 'campaign')
    event.set("[page][acquisition][campaign_campaign]", self.get_param(destination, "utm_campaign"))
    event.set("[page][acquisition][campaign_medium]", self.get_param(destination, "utm_medium"))
    event.set("[page][acquisition][campaign_source]", self.get_param(destination, "utm_source"))
  end

  public
  def direct(event)
    event.set("[page][acquisition][tipo]", 'direct')
  end
end # class LogStash::Filters::Acquisition
