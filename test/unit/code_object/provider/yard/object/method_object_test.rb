require File.expand_path(File.dirname(__FILE__) + '/../../../../../test_helper')

describe ::Inch::CodeObject::Provider::YARD::Parser do
  before do
    @config = Inch::Config.codebase
    @parser = ::Inch::CodeObject::Provider::YARD::Parser.parse(fixture_path(:simple), @config)
    @objects = @parser.objects
  end

  it "should work for Overloading#params_only_in_overloads" do
    m = @objects.detect { |o| o.fullname == 'Overloading#params_only_in_overloads' }
    refute m.signatures.empty?

    signature = m.signatures[0]
    assert_equal "params_only_in_overloads(user_options = {})", signature.signature
    assert_equal 1, signature.parameters.size
    refute signature.parameter(:user_options).nil?
    assert signature.has_code_example?
    assert signature.has_doc?

    signature = m.signatures[1]
    assert_equal "params_only_in_overloads()", signature.signature
    assert signature.parameters.empty?, "Should have been empty: #{signature.parameters.inspect}"
    assert signature.has_code_example?
    refute signature.has_doc?

    signature = m.signatures[2]
    assert_equal "params_only_in_overloads(transaction_id)", signature.signature
    assert_equal 1, signature.parameters.size
    refute signature.parameter(:transaction_id).nil?
    assert signature.has_code_example?
    refute signature.has_doc?
  end
end
