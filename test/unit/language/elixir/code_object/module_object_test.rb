require File.expand_path(File.dirname(__FILE__) + '/../../../../test_helper')

describe ::Inch::Language::Elixir::CodeObject::ModuleObject do
  before do
    @codebase = fresh_codebase(:elixir, :inch_test, 'all.json')
    @objects = @codebase.objects
  end

  describe 'Scores' do
    #
    it 'should not' do
      m = @objects.find('InchTest.Functions')
      refute m.docstring.empty?
      refute m.undocumented?
      assert m.score >= 50
    end
  end

  it 'should recognize moduledoc' do
    m = @objects.find('InchTest.Invisible')
    # defined in Hello-World-Elixir, but not in report since
    # `@moduledoc false` excludes it
    assert m.nil?
  end

  it 'should recognize moduledoc' do
    m = @objects.find('InchTest.Invisible.foo')
    # defined in Hello-World-Elixir, but not in report since
    # `@moduledoc false` excludes it
    assert m.nil?
  end

  it 'should recognize protocols' do
    m = @objects.find('InchTest.Html.Safe')
    refute m.nodoc?
  end

  it 'should recognize implementations' do
    m = @objects.find('InchTest.Html.Safe.Atom')
    assert m.nodoc?
    assert m.priority < 0
  end
end
