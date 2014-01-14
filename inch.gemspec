# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'inch/version'

Gem::Specification.new do |spec|
  spec.name          = "inch"
  spec.version       = Inch::VERSION
  spec.authors       = ["René Föhring"]
  spec.email         = ["rf@bamaru.de"]
  spec.summary       = %q{Wrapper for YARD}
  spec.description   = %q{Wrapper for YARD}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.5"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "yard"
  spec.add_development_dependency 'term-ansicolor'
  spec.add_development_dependency 'pry'
end
