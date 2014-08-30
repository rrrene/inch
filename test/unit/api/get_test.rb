require File.expand_path(File.dirname(__FILE__) + '/../../test_helper')

describe ::Inch::API::Get do
  before do
    @codebase = test_codebase(:ruby, :simple)
  end

  it 'should work' do
    @object_names = ['Foo', 'Foo::Bar']
    @context = ::Inch::API::Get.new @codebase, @object_names
    assert_equal 2, @context.objects.size
    refute @context.object.nil?
    refute @context.grade_lists.empty?
  end

  it 'should work with wildcard' do
    @object_names = ['Foo', 'Foo::Bar#']
    @context = ::Inch::API::Get.new @codebase, @object_names
    assert @context.objects.size > 2
  end
end
