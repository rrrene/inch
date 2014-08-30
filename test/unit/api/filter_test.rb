require File.expand_path(File.dirname(__FILE__) + '/../../test_helper')

describe ::Inch::API::Filter do
  before do
    @codebase = test_codebase(:ruby, :simple)
  end

  it 'should work' do
    @options = {}
    @context = ::Inch::API::Filter.new @codebase, @options
    refute @context.objects.empty?
    refute @context.grade_lists.empty?
  end

  it 'should work with option: visibility == :public' do
    @options = { visibility: [:public] }
    @context = ::Inch::API::Filter.new @codebase, @options
    assert @context.objects.all? { |o| o.public? }
  end

  it 'should work with option: visibility == :protected' do
    @options = { visibility: [:protected] }
    @context = ::Inch::API::Filter.new @codebase, @options
    assert @context.objects.all? { |o| o.protected? }
  end

  it 'should work with option: visibility == :private' do
    @options = { visibility: [:private] }
    @context = ::Inch::API::Filter.new @codebase, @options
    assert @context.objects.all? { |o| o.private? || o.tagged_as_private? }
  end

  it 'should work with option: namespaces == :only' do
    @options = { namespaces: :only }
    @context = ::Inch::API::Filter.new @codebase, @options
    assert @context.objects.all? { |o| o.namespace? }
  end

  it 'should work with option: undocumented == :only' do
    @options = { undocumented: :only }
    @context = ::Inch::API::Filter.new @codebase, @options
    assert @context.objects.all? { |o| o.undocumented? }
  end

  it 'should work with option: depth == 2' do
    @options = { depth: 2 }
    @context = ::Inch::API::Filter.new @codebase, @options
    refute @context.objects.any? { |o| o.depth > 2 }
  end
end
