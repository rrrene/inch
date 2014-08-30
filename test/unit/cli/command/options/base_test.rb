require File.expand_path(File.dirname(__FILE__) + '/../../../../test_helper')

describe ::Inch::CLI::Command::Options::Base do
  it 'should run parse without errors' do
    @options = ::Inch::CLI::Command::Options::Base.new
    @options.parse(['--no-color'])
  end
end
