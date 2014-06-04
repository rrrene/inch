require 'simplecov'

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))

require 'minitest/autorun'
require 'bundler'
Bundler.require
require 'inch'
require 'inch/cli'

def assert_roles(object, expected, unexpected)
  roles = object.roles.map(&:class)
  unexpected.each do |role|
    refute roles.include?(role), "Should not assign #{role}"
  end
  expected.each do |role|
    assert roles.include?(role), "Should assign #{role}"
  end
end

def count_roles(object, role_class, object_name = nil)
  find_roles(object, role_class, object_name).size
end

def find_roles(object, role_class, object_name = nil)
  object.roles.select do |r|
    r.class == role_class && (object_name.nil? || r.object.name == object_name)
  end
end

def fixture_path(name)
  File.join(File.dirname(__FILE__), "fixtures", name.to_s)
end

module Inch
  module Test
    class << self
      attr_accessor :object_providers

      def codebase(name)
        Inch::Codebase::Proxy.new object_provider(name)
      end

      def object_provider(name)
        self.object_providers ||= {}
        self.object_providers[name] ||= ::Inch::CodeObject::Provider.parse(fixture_path(name))
      end
    end
  end
end

def test_codebase(name)
  codebase = Inch::Test.codebase(name)
  codebase
end
