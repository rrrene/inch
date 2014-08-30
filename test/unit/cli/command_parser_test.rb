require File.expand_path(File.dirname(__FILE__) + '/../../test_helper')

describe ::Inch::CLI::CommandParser do
  before do
    Dir.chdir fixture_path(:ruby, :simple)
    @command_parser = ::Inch::CLI::CommandParser
  end

  it 'should run without args' do
    out, err = capture_io do
      @command = @command_parser.run
    end
    refute out.empty?, 'there should be some output'
    assert err.empty?, 'there should be no errors'
    assert_equal ::Inch::CLI::Command::Suggest, @command.class
  end

  it 'should run Command::Suggest with filelist in args' do
    out, err = capture_io do
      @command = @command_parser.run('suggest', 'lib/**/*.rb', 'app/**/*.rb')
    end
    refute out.empty?, 'there should be some output'
    assert err.empty?, 'there should be no errors'
    assert_equal ::Inch::CLI::Command::Suggest, @command.class
  end

  it 'should run Command::Suggest with only filelist in args' do
    out, err = capture_io do
      @command = @command_parser.run('lib/**/*.rb', 'app/**/*.rb')
    end
    refute out.empty?, 'there should be some output'
    assert err.empty?, 'there should be no errors'
    assert_equal ::Inch::CLI::Command::Suggest, @command.class
  end

  it 'should run Command::Suggest with only switches in args' do
    out, err = capture_io do
      @command = @command_parser.run('--no-color')
    end
    refute out.empty?, 'there should be some output'
    assert err.empty?, 'there should be no errors'
    assert_equal ::Inch::CLI::Command::Suggest, @command.class
  end

  it 'should run Command::List with filelist in args' do
    out, err = capture_io do
      @command = @command_parser.run('list', 'lib/**/*.rb', 'app/**/*.rb')
    end
    refute out.empty?, 'there should be some output'
    assert err.empty?, 'there should be no errors'
    assert_equal ::Inch::CLI::Command::List, @command.class
  end

  it 'should run Command::Show with filelist in args' do
    out, err = capture_io do
      @command = @command_parser.run('show', 'Foo')
    end
    refute out.empty?, 'there should be some output'
    assert err.empty?, 'there should be no errors'
    assert_equal ::Inch::CLI::Command::Show, @command.class
  end

  it 'should output info when run with --help' do
    out, err = capture_io do
      @command = @command_parser.run('--help')
    end
    refute out.empty?, 'there should be some output'
    assert_match(/\bUsage\b.+inch/, out)
    assert err.empty?, 'there should be no errors'
  end
end
