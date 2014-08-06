require File.expand_path(File.dirname(__FILE__) + "/../../test_helper")

describe ::Inch::Codebase::Proxy do
  it "should parse all objects" do
    dir = fixture_path(:simple)
    config = Inch::Config::Codebase.new(["lib/**/*.rb"])
    @codebase = Inch::Codebase::Proxy.parse dir, config
    refute_nil @codebase.objects
  end

  it "should parse given paths" do
    dir = fixture_path(:simple)
    config = Inch::Config::Codebase.new(["app/**/*.rb"])
    @codebase = Inch::Codebase::Proxy.parse dir, config
    assert @codebase.objects.empty?
  end
end
