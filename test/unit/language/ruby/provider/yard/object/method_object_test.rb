require File.expand_path(File.dirname(__FILE__) +
                         '/../../../../../../test_helper')

describe ::Inch::Language::Ruby::Provider::YARD::Parser do
  before do
    @config = Inch::Config.codebase
    @parser = ::Inch::Language::Ruby::Provider::YARD::Parser.parse(
      fixture_path(:ruby, :simple), @config)
    @objects = @parser.objects
  end

  it 'should work for Overloading#params_also_in_overloads' do
    m = @objects.find do |o|
      o.fullname == 'Overloading#params_also_in_overloads'
    end

    assert m.has_code_example?

    assert_equal 3, m.signatures.size
    # at this moment, this counts all parameters in all overloaded signatures
    assert_equal 2, m.parameters.size

    signature = m.signatures[0]
    assert_equal 'params_also_in_overloads(user_options = {})',
                 signature.signature
    assert_equal 1, signature.parameters.size
    refute signature.parameter(:user_options).nil?
    assert signature.has_code_example?
    assert signature.has_doc?

    signature = m.signatures[1]
    assert_equal 'params_also_in_overloads()', signature.signature
    assert signature.parameters.empty?,
           "Should have been empty: #{signature.parameters.inspect}"
    assert signature.has_code_example?
    refute signature.has_doc?

    signature = m.signatures[2]
    assert_equal 'params_also_in_overloads(transaction_id)', signature.signature
    assert_equal 1, signature.parameters.size
    refute signature.parameter(:transaction_id).nil?
    assert signature.has_code_example?
    refute signature.has_doc?
  end

  it 'should work for Overloading#params_only_in_overloads' do
    m = @objects.find do |o|
      o.fullname == 'Overloading#params_only_in_overloads'
    end

    assert m.has_code_example?

    assert_equal 3, m.signatures.size
    # at this moment, this counts all parameters in all overloaded signatures
    assert_equal 2, m.parameters.size

    signature = m.signatures[0]
    assert_equal 'params_only_in_overloads()', signature.signature
    assert signature.parameters.empty?,
           "Should have been empty: #{signature.parameters.inspect}"
    assert signature.has_code_example?
    refute signature.has_doc?

    signature = m.signatures[1]
    assert_equal 'params_only_in_overloads(transaction_id)', signature.signature
    assert_equal 1, signature.parameters.size
    refute signature.parameter(:transaction_id).nil?
    assert signature.has_code_example?
    refute signature.has_doc?

    signature = m.signatures[2]
    assert_equal 'params_only_in_overloads(user_options)', signature.signature
    assert_equal 1, signature.parameters.size
    refute signature.parameter(:user_options).nil?
    assert signature.has_code_example?
    # assert signature.has_doc?
  end

  it 'should work' do
    m = @objects.find do |o|
      o.fullname == 'Foo::Bar#method_with_unstructured_doc'
    end
    assert_equal 1, m.signatures.size
    assert_equal 1, m.parameters.size
  end

  it 'should work 2' do
    m = @objects.find { |o| o.fullname == 'Foo#method_with_splat_parameter' }
    assert_equal 1, m.signatures.size
    assert_equal 1, m.parameters.size
  end

end
