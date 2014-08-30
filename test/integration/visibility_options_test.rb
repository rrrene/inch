require File.expand_path(File.dirname(__FILE__) + '/../test_helper')

describe ::Inch::CLI::Command do
  before do
    Dir.chdir fixture_path(:ruby, :visibility)
    @command = ::Inch::CLI::Command::List
  end

  it 'should run without visibility switches' do
    out, _err = capture_io do
      @command.run('--all')
    end
    refute out.empty?, 'there should be some output'
    assert_match(/\bFoo#public_method\b/, out)
    assert_match(/\bFoo#protected_method\b/, out)
    refute_match(/\bFoo#private_method\b/, out) # has @private tag
    refute_match(/\bFoo#method_with_private_tag\b/, out) # has @private tag
  end

  it 'should run with --no-protected switch' do
    out, _err = capture_io do
      @command.run('--all', '--no-protected')
    end
    refute out.empty?, 'there should be some output'
    assert_match(/\bFoo#public_method\b/, out)
    refute_match(/\bFoo#protected_method\b/, out)
    refute_match(/\bFoo#private_method\b/, out) # has @private tag
    refute_match(/\bFoo#method_with_private_tag\b/, out) # has @private tag
  end

  it 'should run with --no-public switch' do
    out, _err = capture_io do
      @command.run(*%w(--all --no-public))
    end
    refute out.empty?, 'there should be some output'
    refute_match(/\bFoo#public_method\b/, out)
    assert_match(/\bFoo#protected_method\b/, out)
    refute_match(/\bFoo#private_method\b/, out) # has @private tag
    refute_match(/\bFoo#method_with_private_tag\b/, out) # has @private tag
  end

  it 'should run with --no-public --no-protected switch' do
    out, _err = capture_io do
      @command.run(*%w(--all --no-public --no-protected))
    end
    assert out.empty?, 'there should be no output'
    refute_match(/\bFoo#public_method\b/, out)
    refute_match(/\bFoo#protected_method\b/, out)
    refute_match(/\bFoo#private_method\b/, out) # has @private tag
    # has a @private tag, but is really :public
    refute_match(/\bFoo#method_with_private_tag\b/, out)
  end

  it 'should run with --no-public --no-protected --private switch' do
    out, _err = capture_io do
      @command.run(*%w(--all --no-public --no-protected --private))
    end
    refute out.empty?, 'there should be some output'
    refute_match(/\bFoo#public_method\b/, out)
    refute_match(/\bFoo#protected_method\b/, out)
    assert_match(/\bFoo#private_method\b/, out) # has @private tag
    # has a @private tag, but is really :public
    refute_match(/\bFoo#method_with_private_tag\b/, out)
  end

  it 'should run with --no-public switch' do
    out, _err = capture_io do
      @command.run(*%w(--all --no-public))
    end
    refute out.empty?, 'there should be some output'
    refute_match(/\bFoo#public_method\b/, out)
    assert_match(/\bFoo#protected_method\b/, out)
    refute_match(/\bFoo#private_method\b/, out) # has @private tag
    # has a @private tag, but is really :public
    refute_match(/\bFoo#method_with_private_tag\b/, out)
  end

  it 'should run with --no-protected switch' do
    out, _err = capture_io do
      @command.run(*%w(--all --no-protected))
    end
    refute out.empty?, 'there should be some output'
    assert_match(/\bFoo#public_method\b/, out)
    refute_match(/\bFoo#protected_method\b/, out)
    refute_match(/\bFoo#private_method\b/, out) # has @private tag
    # has a @private tag, but is really :public
    refute_match(/\bFoo#method_with_private_tag\b/, out)
  end

end
