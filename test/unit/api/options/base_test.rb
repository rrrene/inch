require File.expand_path(File.dirname(__FILE__) + '/../../../test_helper')

describe ::Inch::API::Options::Base do
  class APIOptionsTest < ::Inch::API::Options::Base
    attribute :foo, :bar
    attribute :baz
    attribute :qux
  end

  it 'should work with a Hash or Struct' do
    @options_hash = { foo: 'foo', baz: 42 }
    @options_struct = OpenStruct.new(@options_hash)

    @options1 = APIOptionsTest.new @options_hash
    @options2 = APIOptionsTest.new @options_struct

    assert_equal 'foo', @options1.foo
    assert_equal 'foo', @options2.foo
    assert_equal 42, @options1.baz
    assert_equal 42, @options2.baz
  end

  it 'should return default values' do
    @options_hash = { baz: 42 }
    @options = APIOptionsTest.new @options_hash

    assert_equal :bar, @options.foo
    assert_equal 42, @options.baz
  end
end
