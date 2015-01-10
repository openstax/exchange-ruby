# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'exchange/client/version'

Gem::Specification.new do |spec|
  spec.name          = "exchange-client"
  spec.version       = Exchange::Client::VERSION
  spec.authors       = ["Kevin Burleigh"]
  spec.email         = ["klb@kindlinglabs"]
  spec.summary       = %q{Ruby client for OpenStax Exchange}
  spec.description   = %q{}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"

  spec.add_development_dependency "rspec"
end
