require File.expand_path(File.dirname(__FILE__) + '/../../test_helper')

describe ::Inch::API::Stats do
  before do
    @codebase = test_codebase(:ruby, :simple)
  end

  it 'should work' do
    @options = {}
    @context = ::Inch::API::Stats.new @codebase, @options
    refute @context.objects.empty?
    refute @context.grade_lists.empty?
  end
end
