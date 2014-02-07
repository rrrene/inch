require File.expand_path(File.dirname(__FILE__) + '/../../test_helper')

describe ::Inch::Codebase::Proxy do
  it "should parse all objects" do
    @codebase = Inch::Codebase::Proxy.new fixture_path(:simple)
    @codebase.parse(["lib/**/*.rb"])
    @objects = @codebase.objects

    refute @objects.empty?
    refute_nil @objects.find("Foo")
    refute_nil @objects.find("Foo::Bar")
    refute_nil @objects.find("Foo::Bar#method_without_doc")

    sum = 0
    @objects.each do |o|
      sum += 1
    end

    assert_equal @objects.size, sum
  end
end
