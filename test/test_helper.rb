require 'simplecov'
SimpleCov.start

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
