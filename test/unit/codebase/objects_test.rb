require File.expand_path(File.dirname(__FILE__) + '/../../test_helper')

describe ::Inch::Codebase::Objects do
  before do
    @codebase = test_codebase(:ruby, :simple)
    @objects = @codebase.objects
  end

  it 'should parse all objects' do
    refute @objects.empty?
  end

  it 'should find some objects' do
    refute_nil @objects.find('Foo')
    refute_nil @objects.find('Foo::Bar')
    refute_nil @objects.find('Foo::Bar#method_without_doc')
  end

  it 'should support iteration' do
    sum = 0
    @objects.each do
      sum += 1
    end
    assert_equal @objects.size, sum
  end
end
