require File.expand_path(File.dirname(__FILE__) + '/../../test_helper')

require 'minitest/autorun'

describe ::Inch::CodeObject::Docstring do

  it "should work" do
text = <<-DOC
Another example.

Params:
+param1+:: param1 line string to be executed by the system
+param2+:: +Proc+ object that takes a pipe object as first and only param (may be nil)
+param3+:: +Proc+ object that takes a pipe object as first and only param (may be nil)
DOC
    docstring = ::Inch::CodeObject::Docstring.new(text)
    assert docstring.mentions_parameter?(:param1)
    assert docstring.mentions_parameter?(:param2)
    assert docstring.mentions_parameter?(:param3)
    refute docstring.contains_code_example?
  end

  it "should work 2" do
text = <<-DOC
Just because format_html is mentioned here, does not mean
the first parameter is mentioned.
DOC
    docstring = ::Inch::CodeObject::Docstring.new(text)
    refute docstring.mentions_parameter?(:format)
    refute docstring.contains_code_example?
  end

  it "should work 3" do
text = <<-DOC
An example of a method using RDoc rather than YARD.

== Parameters:
param1::
  A Symbol declaring some markup language like `:md` or `:html`.

== Returns:
A string in the specified format.
DOC
    docstring = ::Inch::CodeObject::Docstring.new(text)
    refute docstring.contains_code_example?
  end

  it "should work with code example" do
text = <<-DOC
Another example.

  method_with_code_example() # => some value

Params:
+param1+:: param1 line string to be executed by the system
+param2+:: +Proc+ object that takes a pipe object as first and only param (may be nil)
+param3+:: +Proc+ object that takes a pipe object as first and only param (may be nil)
DOC
    docstring = ::Inch::CodeObject::Docstring.new(text)
    assert docstring.contains_code_example?
  end

  it "should work with code example 2" do
text = <<-DOC
Just because format_html is mentioned here, does not mean
the first parameter is mentioned.

  method_with_code_example() # => some value
  method_with_missing_param_doc(param1, param2, param3)
DOC
    docstring = ::Inch::CodeObject::Docstring.new(text)
    assert docstring.contains_code_example?
  end

  it "should work with code example 3" do
text = <<-DOC
An example of a method using RDoc rather than YARD.

  method_with_code_example() # => some value

== Parameters:
param1::
  A Symbol declaring some markup language like `:md` or `:html`.

== Returns:
A string in the specified format.
DOC
    docstring = ::Inch::CodeObject::Docstring.new(text)
    assert docstring.contains_code_example?
  end
end
