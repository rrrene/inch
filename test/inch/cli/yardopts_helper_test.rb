require File.expand_path(File.dirname(__FILE__) + '/../../test_helper')

describe ::Inch::CLI::Command::List do
  before do
    Dir.chdir fixture_path(:yardopts)
    assert File.file?(".yardopts")
    @command = ::Inch::CLI::Command::List.new
  end

  it "should run without args" do
    out, err = capture_io do
      @command.run()
    end
    refute out.empty?, "there should be some output"
    assert err.empty?, "there should be no errors"
    assert_match /\bFoo\b/, out
    assert_match /\bFoo::Bar\b/, out
    assert_match /\bFoo::Bar#initialize\b/, out
  end

  it "should run with --no-yardopts" do
    out, err = capture_io do
      @command.run("app/**/*.rb", "--no-yardopts")
    end
    assert out.empty?, "there should be no output"
    assert err.empty?, "there should be no errors"
  end

  it "should output info when run with --help" do
    out, err = capture_io do
      assert_raises(SystemExit) { @command.run("--help") }
    end
    refute out.empty?, "there should be some output"
    assert_match /\bUsage\b.+list/, out
    #assert_match /\b\-\-\[no\-\]yardopts\b/, out, "--[no-]yardopts should be mentioned"
    assert err.empty?, "there should be no errors"
  end
end
