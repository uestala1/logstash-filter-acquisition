Gem::Specification.new do |s|
  s.name          = 'logstash-filter-acquisition'
  s.version       = '0.1.0'
  s.licenses      = ['Apache License (2.0)']
  s.summary       = 'Filter plugin for logstash to get http acquisition values'
  s.homepage      = 'http://www.acc.com.es'
  s.authors       = ['Unai Estala']
  s.email         = 'unai@acc.com.es'
  s.require_paths = ['lib', 'json']

  # Files
  s.files = Dir['lib/**/*','json/*','spec/**/*','vendor/**/*','*.gemspec','*.md','CONTRIBUTORS','Gemfile','LICENSE','NOTICE.TXT']
   # Tests
  s.test_files = s.files.grep(%r{^(test|spec|features)/})

  # Special flag to let us know this is actually a logstash plugin
  s.metadata = { "logstash_plugin" => "true", "logstash_group" => "filter" }

  # Gem dependencies
  s.add_runtime_dependency "logstash-core-plugin-api", "~> 2.0"
  s.add_development_dependency 'logstash-devutils'
end
