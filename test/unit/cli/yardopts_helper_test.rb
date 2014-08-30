require File.expand_path(File.dirname(__FILE__) + '/../../test_helper')

describe ::Inch::CLI::YardoptsHelper do
  before do
    Dir.chdir fixture_path(:ruby, :yardopts)
    assert File.file?('.yardopts')
    @command = ::Inch::CLI::Command::List
  end

  it 'should run without args' do
    out, err = capture_io do
      @command.run
    end
    refute out.empty?, 'there should be some output'
    assert err.empty?, 'there should be no errors'
    assert_match(/\bFoo\b/, out)
    assert_match(/\bFoo::Bar\b/, out)
    assert_match(/\bFoo::Bar#initialize\b/, out)
  end

  it 'should run with --no-yardopts' do
    out, err = capture_io do
      @instance = @command.run('app/**/*.rb', '--no-yardopts')
    end
    assert out.empty?, 'there should be no output'
    assert err.empty?, 'there should be no errors'
  end

  it 'should run with a given path and .yardopts' do
    out, err = capture_io do
      # lib/something*.rb doesnot exist in the fixture, it is just given as
      # a command-line path to check if it appears in the parsed filelist
      @instance = @command.run('lib/something*.rb')
    end
    refute out.empty?, 'there should be no output'
    assert err.empty?, 'there should be no errors'
  end

  it 'should parse options with --no-yardopts' do
    @options = ::Inch::CLI::Command::Options::List.new
    @options.parse(['app/**/*.rb', '--no-yardopts'])
    assert_equal ['app/**/*.rb'], @options.paths
  end

  it 'should parse options with a given path and .yardopts' do
    # lib/something*.rb doesnot exist in the fixture, it is just given as
    # a command-line path to check if it appears in the parsed filelist
    @options = ::Inch::CLI::Command::Options::List.new
    @options.parse(['lib/something*.rb'])
    assert_equal ['foo/**/*.rb', 'lib/something*.rb'], @options.paths
  end

  it 'should output info when run with --help' do
    out, err = capture_io do
      assert_raises(SystemExit) { @command.run('--help') }
    end
    refute out.empty?, 'there should be some output'
    assert_match(/\bUsage\b.+list/, out)
    # assert_match /\b\-\-\[no\-\]yardopts\b/, out,
    #              "--[no-]yardopts should be mentioned"
    assert err.empty?, 'there should be no errors'
  end
end

describe ::Inch::CLI::YardoptsHelper do
  before do
    Dir.chdir fixture_path(:ruby, :simple)
    refute File.file?('.yardopts')
    refute File.file?('.document')
    @command = ::Inch::CLI::Command::List
  end

  it 'should not interfere with paths in arguments' do
    @options = ::Inch::CLI::Command::Options::List.new
    @options.parse(['lib/**/foo*.rb'])
    assert_equal ['lib/**/foo*.rb'], @options.paths
  end

  it 'should not intefer with --all at the end' do
    @options = ::Inch::CLI::Command::Options::List.new
    @options.parse(['lib/**/foo*.rb', '--all'])
    assert_equal ['lib/**/foo*.rb'], @options.paths
  end

end
