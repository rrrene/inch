require File.expand_path(File.dirname(__FILE__) + '/test_helper')

require 'minitest/autorun'

class TestFixtureSimple < MiniTest::Unit::TestCase
  def setup
    Dir.chdir fixture_path(:simple)
    @source_parser = Inch::SourceParser.run(["lib/**/*.rb"])
  end

  def test_method_without_doc
    m = @source_parser.find_object("Foo::Bar#method_without_doc")
    refute m.has_doc?
    refute m.has_parameters?
    refute m.return_typed?
    assert m.undocumented?

    assert_equal 0, m.evaluation.score
  end

  def test_method_with_missing_param_doc
    m = @source_parser.find_object("Foo::Bar#method_with_missing_param_doc")
    assert m.has_doc?
    assert m.has_parameters?
    assert m.return_typed?

    assert_equal 3, m.parameters.size
    p = m.parameter(:param1)
    assert p.mentioned?
    p = m.parameter(:param2)
    assert p.mentioned?
    p = m.parameter(:param3)
    refute p.mentioned?
  end

  def test_method_with_wrong_doc
    m = @source_parser.find_object("Foo::Bar#method_with_wrong_doc")
    assert m.has_doc?
    assert m.has_parameters?
    assert m.return_typed?

    assert_equal 4, m.parameters.size
    p = m.parameter(:param1)
    assert p.mentioned?         # mentioned in docs, correctly
    refute p.wrongly_mentioned?
    p = m.parameter(:param2)
    refute p.mentioned?
    refute p.wrongly_mentioned? # not mentioned in docs at all
    p = m.parameter(:param3)
    refute p.mentioned?
    refute p.wrongly_mentioned? # not mentioned in docs at all
    p = m.parameter(:param4)
    assert p.mentioned?
    assert p.wrongly_mentioned? # mentioned in docs, but not present
  end

  def test_method_with_full_doc
    m = @source_parser.find_object("Foo::Bar#method_with_full_doc")
    assert m.has_doc?
    assert m.has_parameters?
    assert m.return_typed?

    assert_equal 2, m.parameters.size
    m.parameters.each do |param|
      assert param.mentioned?
      assert param.typed?
      assert param.described?
      refute param.wrongly_mentioned?
    end

    assert_equal 100, m.evaluation.score
  end

  def test_method_without_params_or_return_type
    m = @source_parser.find_object("Foo::Bar#method_without_params_or_return_type")
    assert m.has_doc?
    refute m.has_parameters?
    refute m.return_typed?
  end

  def test_method_without_docstring
    m = @source_parser.find_object("Foo::Bar#method_without_docstring")
    refute m.has_doc?
    assert m.has_parameters?
    assert m.return_typed?
  end
end
