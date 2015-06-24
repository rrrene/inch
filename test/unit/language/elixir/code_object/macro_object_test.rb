require File.expand_path(File.dirname(__FILE__) + '/../../../../test_helper')

describe ::Inch::Language::Elixir::CodeObject::FunctionObject do
  before do
    @codebase = fresh_codebase(:elixir, :inch_test, 'all.json')
    @objects = @codebase.objects
  end

  describe 'Scores' do
    #
    it 'should not' do
      m = @objects.find('InchTest.Macros.full_doc/0')
      assert m.score >= 50
    end
    #
    it 'should recognize @doc false' do
      m = @objects.find('InchTest.Macros.no_doc/0')
      assert m.nodoc?
    end
    #
    it 'should not' do
      m = @objects.find('InchTest.Macros.missing_doc/0')
      assert m.score == 0
      assert m.undocumented?
    end
  end
end
