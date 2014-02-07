require File.expand_path(File.dirname(__FILE__) + '/../../test_helper')

describe ::Inch::Codebase::Proxy do
  it "should parse all objects" do
    @codebase = Inch::Codebase::Proxy.new fixture_path(:simple)
    @codebase.parse(["lib/**/*.rb"])
    refute_nil @codebase.objects
  end
end
