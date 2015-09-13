# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rtl_that_string/version'

Gem::Specification.new do |spec|
  spec.name          = "rtl_that_string"
  spec.version       = RtlThatString::VERSION
  spec.authors       = ["Craig Day"]
  spec.email         = ["cday@zendesk.com"]

  spec.summary       = %q{Small library to wrap text/html in RTL markers/tags}
  spec.description   = %q{Small library to wrap text/html in RTL markers/tags}
  spec.homepage      = "https://github.com/craig-day/"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "string-direction", "~> 1.0"

  spec.add_development_dependency "bundler", "~> 1.10"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "bump"
end
