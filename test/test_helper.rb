require 'simplecov'
SimpleCov.start do
  add_filter '/test/'

  add_group 'CLI', 'lib/inch/cli'
  add_group 'Code Objects', 'lib/inch/code_object'
  add_group 'Evaluation', 'lib/inch/evaluation'
end

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))

require 'minitest/spec'
require 'minitest/autorun'
require 'bundler'
Bundler.require
require 'inch'

def fixture_path(name)
  File.join(File.dirname(__FILE__), "fixtures", name.to_s)
end

def in_fixture_path(name, &block)
  old_dir = Dir.pwd
  Dir.chdir fixture_path(name)
  yield
  Dir.chdir old_dir
end
