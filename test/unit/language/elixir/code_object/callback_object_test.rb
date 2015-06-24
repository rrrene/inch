require File.expand_path(File.dirname(__FILE__) + '/../../../../test_helper')

describe ::Inch::Language::Elixir::CodeObject::FunctionObject do
  before do
    @codebase = fresh_codebase(:elixir, :inch_test, 'all.json')
    @objects = @codebase.objects
  end

  describe 'Scores' do
    #
    it 'should not' do
      m = @objects.find('InchTest.Callbacks.full_doc/1')
      assert m.score >= 50
    end
    #
    it 'should recognize @doc false' do
      m = @objects.find('InchTest.Callbacks.no_doc/1')
      assert m.nodoc?
    end
    #
    it 'should not' do
      m = @objects.find('InchTest.Callbacks.missing_doc/1')
      assert m.score == 0
      assert m.undocumented?
    end
  end
end
