require File.expand_path(File.dirname(__FILE__) + '/../../../test_helper')

describe ::Inch::CLI::Command::Console do
  before do
    @command = ::Inch::CLI::Command::Base.new
  end

  it 'should implement some defaults' do
    assert @command.name
    assert @command.usage
    assert @command.description

    assert_raises(NotImplementedError) { @command.run('something') }
  end
end
