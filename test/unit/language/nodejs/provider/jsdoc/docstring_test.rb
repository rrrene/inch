require File.expand_path(File.dirname(__FILE__) + '/../../../../../test_helper')

describe ::Inch::Language::Nodejs::Provider::JSDoc::Docstring do
  let(:described_class) { ::Inch::Language::Nodejs::Provider::JSDoc::Docstring }

  #
  # JSDoc compatibility
  #

  it 'should notice things in jsdoc style docs' do
    text = <<-DOC
  /**
   * Set or get the context `Runnable` to `runnable`.
   *
   * @param {Runnable} runnable the runnable to execute
   * @return {Context} the context
   * @api private
   */
    DOC
    docstring = described_class.new(text)
    assert docstring.mentions_parameter?(:runnable)
    assert docstring.describes_parameter?(:runnable)
    assert docstring.describes_internal_api?
    assert docstring.mentions_return?
    assert docstring.describes_return?
  end

  it 'should notice things in jsdoc style docs 2' do
    text = <<-DOC
  /**
   * Set or get the context `Runnable` to `runnable`.
   *
   * @param {Runnable} runnable
   * @return {Context}
   */
    DOC
    docstring = described_class.new(text)
    assert docstring.mentions_parameter?(:runnable)
    refute docstring.describes_parameter?(:runnable)
    refute docstring.describes_internal_api?
    assert docstring.mentions_return?
    refute docstring.describes_return?
  end

  it 'should notice things in jsdoc style docs' do
    %w(public protected private).each do |visibility|
      text = <<-DOC
    /**
     * Set or get the context `Runnable` to `runnable`.
     *
     * @#{visibility}
     */
      DOC
      docstring = described_class.new(text)
      assert_equal visibility, docstring.visibility
    end
  end


  # removing comment slashes

  it 'should remove comment markers for parsing 1' do
    text = <<-DOC
  /**
   * Set or get the context `Runnable` to `runnable`.
   *
   * @param {Runnable} runnable the runnable to execute
   * @return {Context} the context
   * @api private
   */
    DOC
    without_comment_markers = <<-DOC
Set or get the context `Runnable` to `runnable`.

@param {Runnable} runnable the runnable to execute
@return {Context} the context
@api private
    DOC
    docstring = described_class.new(text)
    assert_equal without_comment_markers.strip, docstring.without_comment_markers
  end

  it 'should remove comment markers for parsing 2' do
    text = <<-DOC
  /*
   * Set or get the context `Runnable` to `runnable`.
   *
   */
    DOC
    without_comment_markers = <<-DOC
Set or get the context `Runnable` to `runnable`.
    DOC
    docstring = described_class.new(text)
    assert_equal without_comment_markers.strip, docstring.without_comment_markers
  end


  it 'should remove comment markers for parsing 3' do
    text = <<-DOC
    //Set or get the context `Runnable` to `runnable`.
    DOC
    without_comment_markers = <<-DOC
Set or get the context `Runnable` to `runnable`.
    DOC
    docstring = described_class.new(text)
    assert_equal without_comment_markers.strip, docstring.without_comment_markers
  end

end
