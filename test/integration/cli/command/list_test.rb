require File.expand_path(File.dirname(__FILE__) + '/../../../test_helper')
require File.expand_path(File.dirname(__FILE__) + '/../../../shared/base_list')

describe ::Inch::CLI::Command::List do
  before do
    Dir.chdir fixture_path(:ruby, :simple)
    @command = ::Inch::CLI::Command::List
  end

  include Shared::BaseList

  it 'should run without args' do
    out, err = capture_io do
      @command.run
    end
    refute out.empty?, 'there should be some output'
    assert err.empty?, 'there should be no errors'
    assert_match(/\bFoo\b/, out)
    assert_match(/\bFoo::Bar\b/, out)
    assert_match(/\bFoo::Bar#method_with_full_doc\b/, out)
    assert_match(/\bFoo::Bar#method_with_code_example\b/, out)
  end

  it 'should run with --numbers switch' do
    out, err = capture_io do
      @command.run('--numbers')
    end
    refute out.empty?, 'there should be some output'
    assert err.empty?, 'there should be no errors'
    assert_match(/\bFoo\b/, out)
    assert_match(/\bFoo::Bar\b/, out)
    assert_match(/\bFoo::Bar#method_with_full_doc\b/, out)
    assert_match(/\bFoo::Bar#method_with_code_example\b/, out)
  end

  it 'should run with filelist in args' do
    out, err = capture_io do
      @command.run('lib/**/*.rb', 'app/**/*.rb')
    end
    refute out.empty?, 'there should be some output'
    assert err.empty?, 'there should be no errors'
    assert_match(/\bFoo\b/, out)
    assert_match(/\bFoo::Bar\b/, out)
    assert_match(/\bFoo::Bar#method_with_full_doc\b/, out)
    assert_match(/\bFoo::Bar#method_with_code_example\b/, out)
  end

  it 'should run with non-existing filelist in args' do
    out, err = capture_io do
      @command.run('app/**/*.rb')
    end
    assert out.empty?, 'there should be no output'
    assert err.empty?, 'there should be no errors'
  end

  it 'should output info when run with --help' do
    out, err = capture_io do
      assert_raises(SystemExit) { @command.run('--help') }
    end
    refute out.empty?, 'there should be some output'
    assert_match(/\bUsage\b.+list/, out)
    assert err.empty?, 'there should be no errors'
  end
end
