require File.expand_path(File.dirname(__FILE__) + '/../../../../test_helper')

describe ::Inch::Language::Elixir::CodeObject::FunctionObject do
  before do
    @codebase = fresh_codebase(:elixir, :inch_test, 'all.json')
    @objects = @codebase.objects
  end

  describe 'Scores' do
    #
    it 'should not' do
      m = @objects.find('InchTest.generate_docs/4')
      assert m.score >= 50
    end
  end

  it 'should recognize the relationship between modules and functions' do
    mod = @objects.find('InchTest')
    assert mod.has_children?
    assert mod.children.size > 1
    fun = @objects.find('InchTest.generate_docs/4')
    assert_equal mod, fun.parent
  end

  it 'should recognize the depth of methods' do
    m = @objects.find('InchTest')
    assert_equal 1, m.depth
    m = @objects.find('InchTest.Config')
    assert_equal 2, m.depth
    m = @objects.find('InchTest.Docs.Formatter')
    assert_equal 3, m.depth
    m = @objects.find('InchTest.Docs.Formatter.run/3')
    assert_equal 4, m.depth
  end

  it "should parse parameters correctly" do
    m = @objects.find("InchTest.Docs.Formatter.run/3")
    assert_equal 3, m.parameters.size
  end

  # TODO: move to own test file
  it "should parse parameters correctly 1" do
    klass = ::Inch::Language::Elixir::Provider::Reader::Object::FunctionObject::FunctionSignature
    fn = klass.new([["args", [], nil ], ["\\\\", [], [["config", [], nil ], [[".", {line: 10 }, ["Elixir.Mix.Project", "config"] ], {line: 10 }, [] ] ] ], ["\\\\", [], [["generator", [], nil ], [[".", [], ["erlang", "make_fun"] ], {line: 10 }, ["Elixir.InchTest", "generate_docs", 4 ] ] ] ], ["\\\\", [], [["reporter", [], nil ], "Elixir.InchTest.Reporter.Local"] ] ])
    assert_equal %w(args config generator reporter), fn.parameter_names
  end
end
