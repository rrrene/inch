require File.expand_path(File.dirname(__FILE__) + '/test_helper')

require 'minitest/autorun'

class TestSourceParser < MiniTest::Unit::TestCase
  def setup
    Dir.chdir fixture_path(:simple)
    @source_parser = Inch::SourceParser.run(["lib/**/*.rb"])
  end

  def test_all_objects_parsed
    refute_nil @source_parser.find_object("Foo")
    refute_nil @source_parser.find_object("Foo::Bar")
    refute_nil @source_parser.find_object("Foo::Bar#method_without_doc")
    refute_nil @source_parser.find_object("Foo::Bar#method_with_missing_param_doc")
    refute_nil @source_parser.find_object("Foo::Bar#method_with_wrong_doc")
    refute_nil @source_parser.find_object("Foo::Bar#method_with_full_doc")
  end
end
