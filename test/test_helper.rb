require 'simplecov'

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))

require 'minitest/autorun'
require 'bundler'
Bundler.require
require 'inch'

def fixture_path(name)
  File.join(File.dirname(__FILE__), "fixtures", name.to_s)
end
