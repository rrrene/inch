require File.expand_path(File.dirname(__FILE__) + '/../../test_helper')

describe ::Inch::CodeObject::Proxy::Base do
  before do
    Dir.chdir fixture_path(:code_examples)
    @source_parser = Inch::SourceParser.run(["lib/**/*.rb"])
  end

  def test_method_with_code_example
    m = @source_parser.find_object("Foo::Bar#method_with_code_example")
    assert m.has_code_example?
  end

  def test_method_with_code_example2
    m = @source_parser.find_object("Foo::Bar#method_with_code_example2")
    assert m.has_code_example?
  end

  def test_method_with_code_examples
    m = @source_parser.find_object("Foo::Bar#method_with_one_example")
    assert m.has_code_example?
    refute m.has_multiple_code_examples?
  end

  def test_method_with_code_examples
    m = @source_parser.find_object("Foo::Bar#method_with_examples")
    assert m.has_multiple_code_examples?
  end

  def test_method_with_code_examples
    m = @source_parser.find_object("Foo::Bar#method_with_tagged_example")
    assert m.has_multiple_code_examples?
  end

  def test_method_with_code_examples
    m = @source_parser.find_object("Foo::Bar#method_with_2tagged_examples")
    assert m.has_multiple_code_examples?
  end
end
