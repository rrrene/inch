require File.expand_path(File.dirname(__FILE__) + '/../../../../../test_helper')

describe ::Inch::Language::Ruby::Provider::YARD::Docstring do
  let(:described_class) { ::Inch::Language::Ruby::Provider::YARD::Docstring }

  #
  # loose TomDoc compatibility
  #

  it 'should notice things in tomdoc style docs' do
    text = <<-DOC
Internal: Detects the Language of the blob.

param1 - String filename
p2     - String blob data. A block also maybe passed in for lazy
       loading. This behavior is deprecated and you should always
       pass in a String.
prm3   - Optional String mode (defaults to nil)

Returns Language or nil.
    DOC
    docstring = described_class.new(text)
    assert docstring.describes_internal_api?
    assert docstring.mentions_parameter?(:param1)
    assert docstring.mentions_parameter?(:p2)
    assert docstring.mentions_parameter?(:prm3)
    assert docstring.describes_parameter?(:param1)
    assert docstring.describes_parameter?(:p2)
    assert docstring.describes_parameter?(:prm3)
    refute docstring.contains_code_example?
    assert docstring.mentions_return?
    assert docstring.describes_return?
  end

  it 'should notice things in tomdoc style docs 2' do
    text = <<-DOC
Public: Look up Language by one of its aliases.

param1 - A String alias of the Language

Examples

  Language.find_by_alias('cpp')
  # => #<Language name="C++">

Returns the Lexer or nil if none was found.
    DOC
    docstring = described_class.new(text)
    assert docstring.mentions_parameter?(:param1)
    assert docstring.describes_parameter?(:param1)
    refute docstring.mentions_parameter?(:alias)
    refute docstring.mentions_parameter?(:Look)
    assert docstring.contains_code_example?
    assert docstring.mentions_return?
    assert docstring.describes_return?
  end

  it 'should notice multi-line returns in tomdoc style docs' do
    text = <<-DOC
Public: Look up Language by one of its aliases.

Returns the Lexer or nil
  if none was found.
    DOC
    docstring = described_class.new(text)
    assert docstring.mentions_return?
    assert docstring.describes_return?
  end

  it 'should notice multi-line returns in tomdoc style docs 2' do
    text = <<-DOC
Public: Look up Language by one of its aliases.

Returns the Lexer or nil
  if none
  was found.
    DOC
    docstring = described_class.new(text)
    assert docstring.mentions_return?
    assert docstring.describes_return?
  end

  it 'should notice things in tomdoc style docs 3' do
    text = <<-DOC
Public: Look up Language by one of its aliases.

param1 - A String alias of the Language

Examples

  Language.find_by_alias('cpp')
  # => #<Language name="C++">

Returns the Lexer or nil if none was found.
    DOC
    docstring = described_class.new(text)
    assert docstring.mentions_parameter?(:param1)
    assert docstring.describes_parameter?(:param1)
    refute docstring.mentions_parameter?(:alias)
    refute docstring.mentions_parameter?(:Look)
    assert docstring.contains_code_example?
    assert docstring.mentions_return?
    assert docstring.describes_return?
  end

  it "should understand 'Returns nil.'" do
    text = <<-DOC
[...]
Returns nil.
    DOC
    docstring = described_class.new(text)
    assert docstring.describes_return?
  end

  it "should understand 'Returns nil.' without fullstop and in lowercase" do
    text = <<-DOC
[...]
returns nil
    DOC
    docstring = described_class.new(text)
    assert docstring.describes_return?
  end

  it "should understand 'Returns nothing.'" do
    text = <<-DOC
[...]
Returns nothing.
    DOC
    docstring = described_class.new(text)
    assert docstring.describes_return?
  end

  it "should understand 'Gets/Sets nothing.'" do
    text = <<-DOC
[...]
Gets/Sets nothing.
    DOC
    docstring = described_class.new(text)
    assert docstring.describes_return?
  end

  it "should understand 'Gets nothing.'" do
    text = <<-DOC
[...]
Gets nothing.
    DOC
    docstring = described_class.new(text)
    assert docstring.describes_return?
  end

  it "should understand 'Sets nothing.'" do
    text = <<-DOC
[...]
Sets nothing.
    DOC
    docstring = described_class.new(text)
    assert docstring.describes_return?
  end

  it "should understand 'Returns nothing.' without fullstop and in lowercase" do
    text = <<-DOC
[...]
returns nothing
    DOC
    docstring = described_class.new(text)
    assert docstring.describes_return?
  end

  it "should understand 'Returns ...' with a visibility modifier in front of" \
     ' it' do
    text = 'Public: Returns the Integer color.'
    docstring = described_class.new(text)
    assert docstring.mentions_return?
    assert docstring.describes_return?
  end

  #
  # PARAMETER MENTIONS
  #

  it 'should work 2' do
    text = <<-DOC
Just because format_html is mentioned here, does not mean
the first parameter is mentioned.
    DOC
    docstring = described_class.new(text)
    refute docstring.mentions_parameter?(:format)
    refute docstring.contains_code_example?
  end

  it 'should work 2 if correct' do
    text = <<-DOC
Just because format is mentioned here, does not mean
the first parameter is meant.
    DOC
    docstring = described_class.new(text)
    refute docstring.mentions_parameter?(:format)
    refute docstring.contains_code_example?
  end

  #
  # CODE EXAMPLES
  #

  it 'should work 3' do
    text = <<-DOC
An example of a method using RDoc rather than YARD.

== Parameters:
param1::
  A Symbol declaring some markup language like `:md` or `:html`.

== Returns:
A string in the specified format.
    DOC
    docstring = described_class.new(text)
    refute docstring.contains_code_example?
  end

  it 'should work with code example' do
    # rubocop:disable Metrics/LineLength
    text = <<-DOC
Another example.

  method_with_code_example() # => some value

Params:
+param1+:: param1 line string to be executed by the system
+param2+:: +Proc+ object that takes a pipe object as first and only param (may be nil)
+param3+:: +Proc+ object that takes a pipe object as first and only param (may be nil)
    DOC
    # rubocop:enable Metrics/LineLength
    docstring = described_class.new(text)
    assert docstring.contains_code_example?
    assert docstring.mentions_parameter?(:param1)
    assert docstring.mentions_parameter?(:param2)
    assert docstring.mentions_parameter?(:param3)
    assert docstring.describes_parameter?(:param1)
    assert docstring.describes_parameter?(:param2)
    assert docstring.describes_parameter?(:param3)
  end

  it 'should recognize several parameter notations' do
    # rubocop:disable Metrics/LineLength
    text = <<-DOC
Params:
+param1<String>+:: param1 line string to be executed by the system
+param2<String,nil>+:: +Proc+ object that takes a pipe object as first and only param (may be nil)
+param3<String|Class>+:: +Proc+ object that takes a pipe object as first and only param (may be nil)
    DOC
    # rubocop:enable Metrics/LineLength
    docstring = described_class.new(text)
    assert docstring.mentions_parameter?(:param1), 'should mention param1'
    assert docstring.mentions_parameter?(:param2), 'should mention param2'
    assert docstring.mentions_parameter?(:param3), 'should mention param3'
    assert docstring.describes_parameter?(:param1), 'should describe param1'
    assert docstring.describes_parameter?(:param2), 'should describe param2'
    assert docstring.describes_parameter?(:param3), 'should describe param3'
  end

  it 'should work with code example 2' do
    text = <<-DOC
Just because format_html is mentioned here, does not mean
the first parameter is mentioned.

  method_with_code_example() # => some value
  method_with_missing_param_doc(param1, param2, param3)
    DOC
    docstring = described_class.new(text)
    assert docstring.contains_code_example?
    assert_equal 1, docstring.code_examples.size
  end

  it 'should work with code example 3' do
    text = <<-DOC
An example of a method using RDoc rather than YARD.

  method_with_code_example() # => some value

== Parameters:
param1::
  A Symbol declaring some markup language like `:md` or `:html`.

== Returns:
A string in the specified format.
    DOC
    docstring = described_class.new(text)
    assert docstring.contains_code_example?
    assert_equal 1, docstring.code_examples.size
    assert docstring.mentions_parameter?(:param1)
    assert docstring.describes_parameter?(:param1)
  end

  it 'should work with multiple code examples' do
    text = <<-DOC
An example of a method using RDoc rather than YARD.

  method_with_code_example() # => some value

Another example of a method:

  Article.__elasticsearch__.create_index! 1, force: true
  Article.__elasticsearch__.create_index! 2, force: true

== Parameters:
param1::
  A Symbol declaring some markup language like `:md` or `:html`.

== Returns:
A string in the specified format.
    DOC
    docstring = described_class.new(text)
    assert docstring.contains_code_example?
    assert_equal 2, docstring.code_examples.size
    assert docstring.code_examples.last.index('create_index! 2')
  end
end
