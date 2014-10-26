# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'inch/version'

Gem::Specification.new do |spec|
  spec.name          = 'inch'
  spec.version       = Inch::VERSION
  spec.authors       = ['René Föhring']
  spec.email         = ['rf@bamaru.de']
  spec.summary       = 'Documentation measurement tool for Ruby'
  spec.description   = 'Documentation measurement tool for Ruby, based on YARD.'
  spec.homepage      = 'http://trivelop.de/inch/'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(/^bin\//) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(/^(test|spec|features)\//)
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.5'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'minitest', '~> 5.2'

  spec.add_dependency 'pry'
  spec.add_dependency 'sparkr', '>= 0.2.0'
  spec.add_dependency 'term-ansicolor'
  spec.add_dependency 'yard', '~> 0.8.7.5'
end
