require File.expand_path(File.dirname(__FILE__) + '/../../../../test_helper')

describe ::Inch::Language::Elixir::CodeObject::FunctionObject do
  before do
    @codebase = fresh_codebase(:elixir, :simple, 'all.json')
    @objects = @codebase.objects
  end

  describe 'Scores' do
    #
    it 'should not' do
      m = @objects.find('InchEx.generate_docs/3')
      assert m.score >= 50
    end
  end

  it 'should recognize the relationship between modules and functions' do
    mod = @objects.find('InchEx')
    assert mod.has_children?
    assert mod.children.size > 1
    fun = @objects.find('InchEx.generate_docs/3')
    assert_equal mod, fun.parent
  end

  it 'should recognize the depth of methods' do
    m = @objects.find('InchEx')
    assert_equal 1, m.depth
    m = @objects.find('InchEx.Config')
    assert_equal 2, m.depth
    m = @objects.find('InchEx.Docs.Formatter')
    assert_equal 3, m.depth
    m = @objects.find('InchEx.Docs.Formatter.run/2')
    assert_equal 4, m.depth
  end

  it "should parse parameters correctly" do
    m = @objects.find("Mix.Tasks.Inch.run/4")
    #assert_equal 4, m.parameters.size
  end

  # TODO: move to own test file
  it "should parse parameters correctly 1" do
    klass = ::Inch::Language::Elixir::Provider::Reader::Object::FunctionObject::FunctionSignature
    fn = klass.new('run/4', "run(args, config \\\\ Mix.Project.config(), generator \\\\ :erlang.make_fun(InchEx, :generate_docs, 3), reporter \\\\ InchEx.Reporter.Local)")
    assert_equal %w(args config generator reporter), fn.parameter_names
  end
end
