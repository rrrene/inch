require File.expand_path(File.dirname(__FILE__) + '/../../../test_helper')

describe ::Inch::CLI::Command::Stats do
  before do
    Dir.chdir fixture_path(:simple)
    @command = ::Inch::CLI::Command::Stats.new
  end

  it "should run without args" do
    out, err = capture_io do
      @command.run()
    end
    refute out.empty?, "there should be some output"
    assert err.empty?, "there should be no errors"
  end

  it "should run with filelist in args" do
    out, err = capture_io do
      @command.run("lib/**/*.rb", "app/**/*.rb")
    end
    refute out.empty?, "there should be some output"
    assert err.empty?, "there should be no errors"
  end

  it "should run even with non-existing filelist in args" do
    out, err = capture_io do
      @command.run("app/**/*.rb")
    end
    refute out.empty?, "there should be some output"
    assert err.empty?, "there should be no errors"
  end

  it "should output info when run with --help" do
    out, err = capture_io do
      assert_raises(SystemExit) { @command.run("--help") }
    end
    refute out.empty?, "there should be some output"
    assert_match /\bUsage\b.+stats/, out
    assert err.empty?, "there should be no errors"
  end
end
