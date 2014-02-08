require File.expand_path(File.dirname(__FILE__) + '/../../test_helper')

describe ::Inch::Codebase::Proxy do
  it "should parse all objects" do
    dir = fixture_path(:simple)
    paths = ["lib/**/*.rb"]
    @codebase = Inch::Codebase::Proxy.new dir, paths
    refute_nil @codebase.objects
  end
end
