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

def fixture_path(language, name)
  File.join(File.dirname(__FILE__), 'fixtures', language.to_s, name.to_s)
end

module Inch
  module Test
    class << self
      attr_accessor :object_providers

      def codebase(language, name)
        Inch::Codebase::Proxy.new language, object_provider(language, name)
      end

      def object_provider(language, name)
        self.object_providers ||= {}
        self.object_providers[name] ||=
          ::Inch::CodeObject::Provider.parse(fixture_path(language, name))
      end
    end
  end
end

def test_codebase(language, name)
  codebase = Inch::Test.codebase(language, name)
  codebase
end

def fresh_codebase(language, name, read_dump_file = nil)
  dir = fixture_path(language, name)
  config = Inch::Config.for(language, dir).codebase
  config.read_dump_file = read_dump_file
  ::Inch::Codebase.parse(dir, config)
end
