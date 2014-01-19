require File.expand_path(File.dirname(__FILE__) + '/../../test_helper')

describe ::Inch::CodeObject::Proxy do
  before do
    Dir.chdir fixture_path(:simple)
    @source_parser ||= Inch::SourceParser.run(["lib/**/*.rb"])
  end

  def test_method_without_doc
    m = @source_parser.find_object("Foo::Bar#method_without_doc")
    refute m.has_doc?
    refute m.has_parameters?
    refute m.return_typed?
    assert m.undocumented?

    assert_equal 0, m.score
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

    assert m.score
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

    assert m.score
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

    assert_equal 100, m.score
  end

  def test_method_without_params_or_return_type
    m = @source_parser.find_object("Foo::Bar#method_without_params_or_return_type")
    assert m.has_doc?
    refute m.has_parameters?
    refute m.return_typed?

    assert m.score
  end

  def test_method_without_docstring
    m = @source_parser.find_object("Foo::Bar#method_without_docstring")
    refute m.has_doc?
    assert m.has_parameters?
    assert m.return_typed?

    assert m.score
  end

  def test_method_without_params_or_docstring
    m = @source_parser.find_object("Foo::Bar#method_without_params_or_docstring")
    refute m.has_doc?
    refute m.has_parameters?
    assert m.return_typed?

    assert m.score
  end

  def test_method_with_rdoc_doc
    m = @source_parser.find_object("Foo::Bar#method_with_rdoc_doc")
    assert m.has_doc?
    assert m.has_parameters?
    p = m.parameter(:param1)
    assert p.mentioned?         # mentioned in docs, correctly
    refute m.return_typed?

    assert m.score
  end

  def test_method_with_other_rdoc_doc
    m = @source_parser.find_object("Foo::Bar#method_with_other_rdoc_doc")
    assert m.has_doc?
    assert m.has_parameters?
    p = m.parameter(:param1)
    assert p.mentioned?         # mentioned in docs, correctly
    p = m.parameter(:param2)
    assert p.mentioned?         # mentioned in docs, correctly
    p = m.parameter(:param3)
    assert p.mentioned?         # mentioned in docs, correctly
    refute m.return_typed?

    assert m.score
  end

  def test_method_with_unstructured_doc
    m = @source_parser.find_object("Foo::Bar#method_with_unstructured_doc")
    assert m.has_doc?
    assert m.has_parameters?
    p = m.parameter(:param1)
    assert p.mentioned?         # mentioned in docs, correctly
    refute m.return_typed?

    assert m.score
  end

  def test_method_with_unstructured_doc_missing_params
    m = @source_parser.find_object("Foo::Bar#method_with_unstructured_doc_missing_params")
    assert m.has_doc?
    assert m.has_parameters?
    p = m.parameter(:format)
    refute p.mentioned?         # mentioned in docs, correctly
    refute m.return_typed?

    assert m.score
  end

  def test_method_with_code_example
    m = @source_parser.find_object("Foo::Bar#method_with_code_example")
    assert m.has_code_example?
  end

  def test_method_with_code_example2
    m = @source_parser.find_object("Foo::Bar#method_with_code_example2")
    assert m.has_code_example?
  end

end
