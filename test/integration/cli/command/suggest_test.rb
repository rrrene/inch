require File.expand_path(File.dirname(__FILE__) + '/../../../test_helper')
require 'inch/utils/buffered_ui'

describe ::Inch::CLI::Command::Suggest do
  before do
    Dir.chdir fixture_path(:ruby, :simple)
    @command = ::Inch::CLI::Command::Suggest
  end

  it 'should run without args' do
    out, err = capture_io do
      @command.run
    end
    refute out.empty?, 'there should be some output'
    assert err.empty?, 'there should be no errors'
    assert_match(/\bFoo::Bar#method_with_wrong_doc\b/, out)
    assert_match(/\bFoo::Bar#method_with_rdoc_doc\b/, out)
    assert_match(/\bFoo::Bar#method_with_unstructured_doc\b/, out)
  end

  it 'should run with --pedantic switch' do
    out, err = capture_io do
      @command.run('--pedantic')
    end
    refute out.empty?, 'there should be some output'
    assert err.empty?, 'there should be no errors'
  end

  it 'should run with filelist in args' do
    out, err = capture_io do
      @command.run('lib/**/*.rb', 'app/**/*.rb')
    end
    refute out.empty?, 'there should be some output'
    assert err.empty?, 'there should be no errors'
    assert_match(/\bFoo::Bar#method_with_wrong_doc\b/, out)
    assert_match(/\bFoo::Bar#method_with_rdoc_doc\b/, out)
    assert_match(/\bFoo::Bar#method_with_unstructured_doc\b/, out)
  end

  it 'should run with non-existing filelist in args' do
    _out, _err = capture_io do
      @command.run('app/**/*.rb')
    end
    # TODO: not sure what should actually happen here:
    #   no output or error message?
    # assert out.empty?, "there should be no output"
    # assert err.empty?, "there should be no errors"
  end

  it 'should run with --objects switch' do
    out, err = capture_io do
      @command.run('lib/**/*.rb', 'app/**/*.rb', '--objects=30')
    end
    refute out.empty?, 'there should be some output'
    assert err.empty?, 'there should be no errors'
    assert_match(/\bFoo::Bar#method_with_wrong_doc\b/, out)
    assert_match(/\bFoo::Bar#method_with_rdoc_doc\b/, out)
    assert_match(/\bFoo::Bar#method_with_unstructured_doc\b/, out)
  end

  it 'should give error when run with --unknown-switch' do
    _out, _err = capture_io do
      assert_raises(SystemExit) { @command.run('--unknown-switch') }
    end
  end

  it 'should output info when run with --help' do
    out, err = capture_io do
      assert_raises(SystemExit) { @command.run('--help') }
    end
    refute out.empty?, 'there should be some output'
    assert_match(/\bUsage\b.+suggest/, out)
    assert err.empty?, 'there should be no errors'
  end

  it 'should output version when run with --version' do
    out, err = capture_io do
      assert_raises(SystemExit) { @command.run('--version') }
    end
    refute out.empty?, 'there should be some output'
    assert_match(/inch\ \d\.\d\.\d/, out)
    assert err.empty?, 'there should be no errors'
  end

  it 'should not output anything to stdout when used with BufferedUI' do
    ui = ::Inch::Utils::BufferedUI.new
    out, err = capture_io do
      @command.run(:ui => ui)
    end
    assert out.empty?, 'there should be no output'
    assert err.empty?, 'there should be no errors'
  end

  # Edge case: Really good codebase

  it 'should run without args on really good fixture' do
    out, err = capture_io do
      Dir.chdir fixture_path(:ruby, :really_good)
      @command.run
    end
    refute out.empty?, 'there should be some output'
    assert err.empty?, 'there should be no errors'
  end

  it 'should run with --pedantic switch' do
    out, err = capture_io do
      Dir.chdir fixture_path(:ruby, :really_good)
      @command.run('--pedantic')
    end
    refute out.empty?, 'there should be some output'
    assert err.empty?, 'there should be no errors'
  end

  it 'should run on elixir codebase with --read-from-dump' do
    out, err = capture_io do
      Dir.chdir fixture_path(:elixir, :inch_test)
      @command.run('--language=elixir', '--read-from-dump=all.json')
    end
    refute out.empty?, 'there should be some output'
    assert err.empty?, 'there should be no errors'
  end

end
