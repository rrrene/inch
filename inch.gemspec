# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'inch/version'

Gem::Specification.new do |spec|
  spec.name          = "inch"
  spec.version       = Inch::VERSION
  spec.authors       = ["René Föhring"]
  spec.email         = ["rf@bamaru.de"]
  spec.summary       = %q{Documentation measurement tool for Ruby}
  spec.description   = %q{Documentation measurement tool for Ruby, based on YARD.}
  spec.homepage      = "http://trivelop.de/inch/"
  spec.license       = "MIT"

  all_files = `git ls-files -z`.split("\x0")
  files_without_dev_commands = all_files.select do |f|
    f !~ /cli\/command\/.*(console|inspect)/
  end

  spec.files         = files_without_dev_commands
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.5"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "pry"
  spec.add_development_dependency "minitest", "~> 5.2"

  spec.add_dependency 'sparkr', ">= 0.2.0"
  spec.add_dependency "term-ansicolor"
  spec.add_dependency "yard", "~> 0.8.7"
end
