require File.expand_path(File.dirname(__FILE__) + '/../../test_helper')

describe ::Inch::CodeObject::Proxy do
  before do
    @codebase = test_codebase(:ruby, :code_examples)
    @objects = @codebase.objects
  end

  def test_inspect_gives_original_name
    m = @objects.find('Foo::Bar#method_with_code_example')
    assert_match(/Foo::Bar#method_with_code_example/, m.inspect)
  end

  def test_grade_is_not_nil
    m = @objects.find('Foo::Bar#method_with_code_example')
    assert m.grade
  end

  def test_method_with_code_example
    m = @objects.find('Foo::Bar#method_with_code_example')
    assert m.has_code_example?
  end

  def test_method_with_code_example2
    m = @objects.find('Foo::Bar#method_with_code_example2')
    assert m.has_code_example?
  end

  def test_method_with_code_examples
    m = @objects.find('Foo::Bar#method_with_one_example')
    assert m.has_code_example?
    refute m.has_multiple_code_examples?
  end

  def test_method_with_code_examples
    m = @objects.find('Foo::Bar#method_with_examples')
    assert m.has_multiple_code_examples?
  end

  def test_method_with_code_examples
    m = @objects.find('Foo::Bar#method_with_tagged_example')
    assert m.has_multiple_code_examples?
  end

  def test_method_with_code_examples
    m = @objects.find('Foo::Bar#method_with_2tagged_examples')
    assert m.has_multiple_code_examples?
  end
end
