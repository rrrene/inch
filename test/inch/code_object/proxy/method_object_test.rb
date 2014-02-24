require File.expand_path(File.dirname(__FILE__) + '/../../../test_helper')

describe ::Inch::CodeObject::Proxy::MethodObject do
  before do
    Dir.chdir fixture_path(:simple)
    @codebase = Inch::Codebase.parse(fixture_path(:simple), ["lib/**/*.rb"])
  end

  def test_transitive_tags_dont_matter
    m = @codebase.objects.find("InchTest::Deprecated::ClassMethods")
    assert_equal 0, m.score
    # assert m.undocumented? # TODO: implement
  end

  def test_method_without_doc
    m = @codebase.objects.find("Foo::Bar#method_without_doc")
    refute m.has_doc?
    refute m.has_parameters?
    refute m.return_mentioned?
    assert m.undocumented?

    assert_equal 0, m.score
  end

  def test_method_with_missing_param_doc
    m = @codebase.objects.find("Foo::Bar#method_with_missing_param_doc")
    assert m.has_doc?
    assert m.has_parameters?
    assert m.return_mentioned?

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
    m = @codebase.objects.find("Foo::Bar#method_with_wrong_doc")
    assert m.has_doc?
    assert m.has_parameters?
    assert m.return_mentioned?

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
    m = @codebase.objects.find("Foo::Bar#method_with_full_doc")
    assert m.has_doc?
    assert m.has_parameters?
    assert m.return_mentioned?

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
    m = @codebase.objects.find("Foo::Bar#method_without_params_or_return_type")
    assert m.has_doc?
    refute m.has_parameters?
    refute m.return_mentioned?

    assert m.score
  end

  def test_method_without_docstring
    m = @codebase.objects.find("Foo::Bar#method_without_docstring")
    refute m.has_doc?
    assert m.has_parameters?
    assert m.return_mentioned?

    assert m.score
  end

  def test_method_without_params_or_docstring
    m = @codebase.objects.find("Foo::Bar#method_without_params_or_docstring")
    refute m.has_doc?
    refute m.has_parameters?
    assert m.return_mentioned?

    assert m.score
  end

  def test_method_with_rdoc_doc
    m = @codebase.objects.find("Foo::Bar#method_with_rdoc_doc")
    assert m.has_doc?
    assert m.has_parameters?
    p = m.parameter(:param1)
    assert p.mentioned?         # mentioned in docs, correctly
    refute m.return_mentioned?

    assert m.score
  end

  def test_method_with_other_rdoc_doc
    m = @codebase.objects.find("Foo::Bar#method_with_other_rdoc_doc")
    assert m.has_doc?
    assert m.has_parameters?
    p = m.parameter(:param1)
    assert p.mentioned?         # mentioned in docs, correctly
    p = m.parameter(:param2)
    assert p.mentioned?         # mentioned in docs, correctly
    p = m.parameter(:param3)
    assert p.mentioned?         # mentioned in docs, correctly
    refute m.return_mentioned?

    assert m.score
  end

  def test_method_with_unstructured_doc
    m = @codebase.objects.find("Foo::Bar#method_with_unstructured_doc")
    assert m.has_doc?
    assert m.has_parameters?
    p = m.parameter(:param1)
    assert p.mentioned?         # mentioned in docs, correctly
    refute m.return_mentioned?

    assert m.score
  end

  def test_method_with_unstructured_doc_missing_params
    m = @codebase.objects.find("Foo::Bar#method_with_unstructured_doc_missing_params")
    assert m.has_doc?
    assert m.has_parameters?
    p = m.parameter(:format)
    refute p.mentioned?         # mentioned in docs, correctly
    refute m.return_mentioned?

    assert m.score
  end

  def test_question_mark_method
    m = @codebase.objects.find("InchTest#question_mark_method?")
    refute m.has_doc?
    refute m.has_parameters?

    assert_equal 0, m.score
  end

  def test_question_mark_method_with_description
    m = @codebase.objects.find("InchTest#question_mark_method_with_description?")
    refute m.has_doc?
    refute m.has_parameters?

    assert m.score > 0
    assert m.score >= 50 # TODO: don't use magic numbers
  end

  def test_method_with_description_and_parameters
    m = @codebase.objects.find("InchTest#method_with_description_and_parameters?")
    refute m.has_doc?
    assert m.has_parameters?

    assert m.score > 0
  end

  def test_depth
    m = @codebase.objects.find("#root_method")
    assert_equal 1, m.depth
    m = @codebase.objects.find("InchTest#getter")
    assert_equal 2, m.depth
    m = @codebase.objects.find("Foo::Bar#method_without_doc")
    assert_equal 3, m.depth
  end

  def test_getter
    m = @codebase.objects.find("InchTest#getter")
    assert m.getter?, "should be a getter"
    refute m.setter?
  end

  def test_setter
    m = @codebase.objects.find("InchTest#attr_setter=")
    refute m.getter?
    assert m.setter?, "should be a setter"
  end

  def test_setter2
    m = @codebase.objects.find("InchTest#manual_setter=")
    refute m.getter?
    assert m.setter?, "should be a setter"
  end

  def test_manual_getset
    m = @codebase.objects.find("InchTest#manual_getset")
    assert m.getter?, "should be a getter"
    refute m.setter?
  end

  def test_manual_getset2
    m = @codebase.objects.find("InchTest#manual_getset=")
    refute m.getter?
    assert m.setter?, "should be a setter"
  end

  def test_attr_getset
    m = @codebase.objects.find("InchTest#attr_getset")
    assert m.getter?, "should be a getter"
    refute m.setter?
  end

  def test_attr_getset2
    m = @codebase.objects.find("InchTest#attr_getset=")
    refute m.getter?
    assert m.setter?, "should be a setter"
  end

  def test_splat_parameter_notation
    m1 = @codebase.objects.find("Foo#method_with_splat_parameter")
    m2 = @codebase.objects.find("Foo#method_with_splat_parameter2")
    assert_equal m1.score, m2.score
  end
end
