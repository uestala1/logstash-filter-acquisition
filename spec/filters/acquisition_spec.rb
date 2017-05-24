# encoding: utf-8
require_relative '../spec_helper'
require "logstash/filters/acquisition"

describe LogStash::Filters::Acquisition do

  describe "Filtro para referral" do
    let(:config) do <<-CONFIG
      filter {
        acquisition {
          referer => "http://www.acc.com.es"
          destination => "http://www.kukimba.com"
        }
      }
    CONFIG
    end

    sample("referer" => "http://www.acc.com.es") do
      expect(subject.get('[acquisition][referer]')).to eq('http://www.acc.com.es')
      expect(subject.get('[acquisition][tipo]')).to eq('referral')
    end
  end

  describe "Filtro para seo" do
    let(:config) do <<-CONFIG
      filter {
        acquisition {
          referer => "http://www.google.com?q=ejemplo"
          destination => "http://www.acc.com.es"
        }
      }
    CONFIG
    end

    sample("referer" => "http://www.google.com?q=ejemplo") do
      expect(subject.get('[acquisition][referer]')).to eq('http://www.google.com?q=ejemplo')
      expect(subject.get('[acquisition][tipo]')).to eq('seo')
      expect(subject.get('[acquisition][seo_keyword]')).to eq('ejemplo')
    end
  end

  describe "Filtro para campaña" do
    let(:config) do <<-CONFIG
      filter {
        acquisition {
          referer => ""
          destination => "http://www.acc.com.es?utm_campaign=campana1&utm_medium=campana2&utm_source=campana3"
        }
      }
    CONFIG
    end

    sample("referer" => "") do
      expect(subject.get('[acquisition][referer]')).to eq('')
      expect(subject.get('[acquisition][tipo]')).to eq('campaign')
      expect(subject.get('[acquisition][campaign_source]')).to eq('campana3')
      expect(subject.get('[acquisition][campaign_medium]')).to eq('campana2')
      expect(subject.get('[acquisition][campaign_campaign]')).to eq('campana1')
    end
  end

  describe "Filtro para direct" do
    let(:config) do <<-CONFIG
      filter {
        acquisition {
          referer => ""
          destination => "http://www.acc.com.es"
        }
      }
    CONFIG
    end

    sample("referer" => "") do
      expect(subject.get('[acquisition][referer]')).to eq('')
      expect(subject.get('[acquisition][tipo]')).to eq('direct')
    end
  end

  describe "Filtro para social" do
    let(:config) do <<-CONFIG
      filter {
        acquisition {
          referer => "https://plus.url.google.es/acc-comunicacion"
          destination => "http://www.acc.com.es"
        }
      }
    CONFIG
    end

    sample("referer" => "https://plus.url.google.es/acc-comunicacion") do
      expect(subject.get('[acquisition][referer]')).to eq('https://plus.url.google.es/acc-comunicacion')
      expect(subject.get('[acquisition][tipo]')).to eq('social')
    end
  end

end
