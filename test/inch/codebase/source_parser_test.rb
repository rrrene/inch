require File.expand_path(File.dirname(__FILE__) + '/../../test_helper')

describe ::Inch::Codebase::SourceParser do
  it "should parse all objects" do
    Dir.chdir fixture_path(:simple)
    @source_parser = Inch::Codebase::SourceParser.run(["lib/**/*.rb"], [])
    refute @source_parser.yard_objects.empty?
  end
end
