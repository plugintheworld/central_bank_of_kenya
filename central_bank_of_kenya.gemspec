Gem::Specification.new do |s|
  s.name         = 'central_bank_of_kenya'
  s.version      = '0.1.0'
  s.platform     = Gem::Platform::RUBY
  s.date         = '2015-05-24'
  s.summary      = 'Retrieves historic KES exchange rates from the Central Bank of Kenya'
  s.description  = 'Wraps a simple scraper to retrieve the historic exchange rates for Kenyanian
                    shilling (KES). Returns the average (between buy and sell) rates for any yesterday
                    or any day specified and supported by the Central Bank of Kenya.'
  s.authors      = ['Franziska Burmeister-Naß']
  s.email        = ['']
  s.homepage     = 'http://github.com/plugintheworld/central_bank_of_kenya'
  s.license      = 'GPL'

  s.add_runtime_dependency 'nokogiri', '~> 1.6'
  s.add_development_dependency 'rspec', '~> 3.3'
  s.add_development_dependency 'nyan-cat-formatter'

  s.require_path = 'lib'
  s.files        = Dir.glob('lib/**/*') + %w(LICENSE README.md)
end
