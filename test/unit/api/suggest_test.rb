require File.expand_path(File.dirname(__FILE__) + '/../../test_helper')

describe ::Inch::API::Suggest do
  before do
    @codebase = test_codebase(:ruby, :simple)
  end

  it 'should work' do
    @options = {}
    @context = ::Inch::API::Suggest.new @codebase, @options
    refute @context.objects.empty?
    refute @context.grade_lists.empty?
  end

  it 'should work with option: object_count' do
    @options = { object_count: 10 }
    @context = ::Inch::API::Suggest.new @codebase, @options

    @options2 = { object_count: 20 }
    @context2 = ::Inch::API::Suggest.new @codebase, @options2

    assert_equal 10, @context.objects.size
    assert_equal 20, @context2.objects.size
  end
end
