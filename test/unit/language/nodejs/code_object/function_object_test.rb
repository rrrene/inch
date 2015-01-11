require File.expand_path(File.dirname(__FILE__) + '/../../../../test_helper')

describe ::Inch::Language::Elixir::CodeObject::FunctionObject do
  before do
    @codebase = fresh_codebase(:nodejs, :inch_test, 'all.json')
    @objects = @codebase.objects
  end

  describe 'Scores' do
    #
    it 'should not' do
      m = @objects.find('InchTest.generate_docs')
      assert m.score >= 50
    end
  end

  it 'should recognize the relationship between modules and functions' do
    skip "InchTest is a member and therefore not counted at the moment"
    mod = @objects.find('InchTest')
    assert mod.has_children?
    assert mod.children.size > 1
    fun = @objects.find('InchTest.generate_docs')
    assert_equal mod, fun.parent
  end

  it 'should recognize the depth of methods' do
    m = @objects.find('InchTest')
    m = @objects.find('InchTest.Docs.Formatter.run')
    assert_equal 4, m.depth
    skip "InchTest is a member and therefore not counted at the moment"

    assert_equal 1, m.depth
    m = @objects.find('InchTest.Config')
    assert_equal 2, m.depth
    m = @objects.find('InchTest.Docs.Formatter')
    assert_equal 3, m.depth
  end

  it 'should parse parameters correctly' do
    m = @objects.find('InchTest.generate_docs')
    assert_equal 4, m.parameters.size
  end

  it 'should parse parameters correctly' do
    m = @objects.find('InchTest.Functions.full_doc')
    assert_equal 2, m.parameters.size
    assert_equal 'A', m.grade.to_s
  end

  it 'should recognize code examples' do
    m = @objects.find('InchTest.CodeExamples.single_code_example')
    assert m.has_code_example?
    refute m.has_multiple_code_examples?

    m = @objects.find('InchTest.CodeExamples.multiple_code_examples')
    assert m.has_code_example?
    assert m.has_multiple_code_examples?
  end
end
