require File.expand_path(File.dirname(__FILE__) + '/../../../../test_helper')

describe ::Inch::CLI::Command::Options::BaseList do
  it 'should run parse without errors' do
    @options = ::Inch::CLI::Command::Options::BaseList.new
    @options.parse(['--no-color'])
    assert_equal false, @options.show_all?
    assert_equal [:public, :protected], @options.visibility
    assert @options.namespaces.nil?
    assert @options.undocumented.nil?
    assert @options.depth.nil?
  end

  it 'should run parse twice without affecting the second run' do
    @options = ::Inch::CLI::Command::Options::BaseList.new
    @options.parse(['--no-public', '--no-protected', '--private'])
    assert_equal [:private], @options.visibility

    @options = ::Inch::CLI::Command::Options::BaseList.new
    @options.parse(['--no-color'])
    assert_equal [:public, :protected], @options.visibility
  end

  it 'should interpret --all options' do
    @options = ::Inch::CLI::Command::Options::BaseList.new
    @options.parse(['--all'])
    assert_equal true, @options.show_all?
  end

  it 'should interpret visibility options' do
    @options = ::Inch::CLI::Command::Options::BaseList.new
    @options.parse(['--no-public', '--no-protected', '--private'])
    assert_equal [:private], @options.visibility
  end

  it 'should interpret options' do
    @options = ::Inch::CLI::Command::Options::BaseList.new
    @options.parse(['--no-namespaces', '--no-undocumented', '--depth=2'])
    assert_equal :none, @options.namespaces
    assert_equal :none, @options.undocumented
    assert_equal 2, @options.depth
  end

  it 'should interpret other options' do
    @options = ::Inch::CLI::Command::Options::BaseList.new
    @options.parse(['--only-namespaces', '--only-undocumented'])
    assert_equal :only, @options.namespaces
    assert_equal :only, @options.undocumented
  end
end
