$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "openstax/exchange/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "openstax_exchange"
  s.version     = OpenStax::Exchange::VERSION
  s.authors     = ["JP Slavinsky", "Dante Soares"]
  s.email       = ["jps@kindlinglabs.com", "dms3@rice.edu"]
  s.homepage    = "http://github.com/openstax/exchange-ruby"
  s.summary     = "Ruby common code and bindings and for the 'Exchange' API"
  s.description = "Ruby common code and bindings and for the 'Exchange' API"

  s.files = Dir["lib/**/*"] + ["MIT-LICENSE", "Rakefile", "README.md"]
  s.test_files = Dir["spec/**/*"]

  s.add_dependency "oauth2", ">= 0.5.0"

  s.add_development_dependency "rails", ">= 3.1"
  s.add_development_dependency "sqlite3"
  s.add_development_dependency "rspec-rails"
  s.add_development_dependency "capybara"
  s.add_development_dependency "quiet_assets"
  s.add_development_dependency "thin"
end
