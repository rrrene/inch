require File.expand_path(File.dirname(__FILE__) + '/../../test_helper')

describe ::Inch::API::Stats do
  before do
    @dir = fixture_path(:simple)
    @codebase = ::Inch::Codebase.parse(@dir)
  end

  it "should work" do
    @options = {}
    @context = ::Inch::API::Stats.new @codebase, @options
    refute @context.objects.empty?
    refute @context.grade_lists.empty?
  end
end
