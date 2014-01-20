require File.expand_path(File.dirname(__FILE__) + '/../../test_helper')

describe ::Inch::CLI::CommandParser do
  before do
    Dir.chdir fixture_path(:simple)
    @command = ::Inch::CLI::CommandParser
  end

  it "should run without args" do
    out, err = capture_io do
      @command.run()
    end
    refute out.empty?, "there should be some output"
    assert err.empty?, "there should be no errors"
  end

  it "should run Command::Suggest with filelist in args" do
    out, err = capture_io do
      @command.run("suggest", "lib/**/*.rb", "app/**/*.rb")
    end
    refute out.empty?, "there should be some output"
    assert err.empty?, "there should be no errors"
  end

  it "should output info when run with --help" do
    out, err = capture_io do
      @command.run("--help")
    end
    refute out.empty?, "there should be some output"
    assert_match /\bUsage\b.+inch/, out
    assert err.empty?, "there should be no errors"
  end
end
