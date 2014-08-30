require File.expand_path(File.dirname(__FILE__) + '/../../../test_helper')

require 'tmpdir'
require 'fileutils'

describe ::Inch::CLI::Command::Diff do
  before do
    @command = ::Inch::CLI::Command::Diff
    @git_url = 'https://github.com/rrrene/sparkr.git'
    @git_dir = 'sparkr'
    @git_rev1 = '9da8aeaa64ff21daa1b39e3493134d42d67eb71a'
    @git_rev2 = 'HEAD'

    @tmp_dir = Dir.mktmpdir
    # clone the given repo to the tmp_dir
    Dir.chdir @tmp_dir
    `git clone #{@git_url} 2>&1`
    @cloned_dir = File.join(@tmp_dir, @git_dir)
    Dir.chdir @cloned_dir
  end

  after do
    FileUtils.rm_rf @tmp_dir
  end

  it 'should not show any changes' do
    # this runs `inch diff` on a freshly cloned repo
    # should not show any changes
    out, err = capture_io do
      @command.run
    end
    refute out.empty?, 'there should be some output'
    assert err.empty?, 'there should be no errors'
    assert_match(/\bno changes\b/i, out)

    # this runs `inch diff` on two distinct revisions
    # should show some changes
    out, err = capture_io do
      @command.run(@git_rev1, @git_rev2)
    end
    refute out.empty?, 'there should be some output'
    assert err.empty?, 'there should be no errors'
    assert_match(/\bshowing changes\b/i, out)

    # we now remove all comments in a single file
    filename = File.join(@cloned_dir, 'lib/sparkr.rb')
    content = File.read(filename)
    content_without_comments = content.gsub(/\s+#(.+)/, '')
    File.open(filename, 'w') { |f| f.write(content_without_comments) }

    # running the standard `inch diff` again
    # should now show some changes
    out, err = capture_io do
      @command.run
    end
    refute out.empty?, 'there should be some output'
    assert err.empty?, 'there should be no errors'
    assert_match(/\bshowing changes\b/i, out)
  end
end
