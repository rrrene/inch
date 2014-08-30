require File.expand_path(File.dirname(__FILE__) + '/../../../test_helper')

describe ::Inch::CLI::Command::Show do
  before do
    Dir.chdir fixture_path(:ruby, :simple)
    @command = ::Inch::CLI::Command::Show
  end

  it 'should warn and exit when run without args' do
    out, err = capture_io do
      assert_raises(SystemExit) { @command.run }
    end
    assert out.empty?, 'there should be no output'
    refute err.empty?, 'there should be some error message'
  end

  it 'should output info when run with --help' do
    out, err = capture_io do
      assert_raises(SystemExit) { @command.run('--help') }
    end
    refute out.empty?, 'there should be some output'
    assert_match(/\bUsage\b.+show/, out)
    assert err.empty?, 'there should be no errors'
  end

  it 'should output some info when run with a definitive object name' do
    out, err = capture_io do
      @command.run('Foo::Bar#method_with_full_doc', '--no-color')
    end
    refute out.empty?, 'there should be some output'
    assert_match(/\bFoo::Bar#method_with_full_doc\b/, out)
    refute_match(/\b Foo::Bar#method_without_doc\b/, out)
    assert err.empty?, 'there should be no errors'
  end

  it 'should output all children info when run with a partial name' do
    out, err = capture_io do
      @command.run('Foo::Bar#', '--no-color')
    end
    refute out.empty?, 'there should be some output'
    assert_match(/\bFoo::Bar#method_without_doc\b/, out)
    assert_match(/\bFoo::Bar#method_with_full_doc\b/, out)
    assert err.empty?, 'there should be no errors'
  end

  it 'should output colored information' do
    out, _err = capture_io do
      @command.run('Foo::Bar#')
    end
    refute_equal out.uncolor, out, 'should be colored'
  end

  it 'should output uncolored information when asked' do
    out, _err = capture_io do
      @command.run('Foo::Bar#', '--no-color')
    end
    assert_equal out.uncolor, out, 'should not be colored'
  end
end
