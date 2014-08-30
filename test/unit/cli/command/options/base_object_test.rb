require File.expand_path(File.dirname(__FILE__) + '/../../../../test_helper')

describe ::Inch::CLI::Command::Options::BaseObject do
  it 'should run parse without errors' do
    @options = ::Inch::CLI::Command::Options::BaseObject.new
    @options.parse(['--no-color'])
  end

  it 'should interpret options' do
    @options = ::Inch::CLI::Command::Options::BaseObject.new
    @options.parse(['Foo', 'Foo::Bar', '--no-color'])
    assert_equal ['Foo', 'Foo::Bar'], @options.object_names
  end
end
