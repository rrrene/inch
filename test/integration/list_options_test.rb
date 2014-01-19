require File.expand_path(File.dirname(__FILE__) + '/../test_helper')

#
# Tests with the YARD specific --no-public, --no-protected and --no-private
# switches can't be run in one test instance. The flags seem to add up after
# being called. In combination with a random test order this resulted in ever
# different failure outputs.
#
# Therefore, here are some integration tests:
#
describe ::Inch::CLI::Command::List do
  before do
    Dir.chdir fixture_path(:simple)
    @command = "bundle exec inch list"
  end

  it "should run with --no-private switch" do
    out = %x|#{@command} --full --no-private|
    refute out.empty?, "there should be some output"
    assert_match /\bFoo#public_method\b/, out
    assert_match /\bFoo#protected_method\b/, out
    refute_match /\bFoo#private_method\b/, out # has @private tag
    refute_match /\bFoo#method_with_private_tag\b/, out # has @private tag
  end

  it "should run with --no-protected switch" do
    out = %x|#{@command} --full --no-protected|
    refute out.empty?, "there should be some output"
    assert_match /\bFoo#public_method\b/, out
    refute_match /\bFoo#protected_method\b/, out
    refute_match /\bFoo#private_method\b/, out # has @private tag
    refute_match /\bFoo#method_with_private_tag\b/, out # has @private tag
  end

  it "should run with --no-public switch" do
    out = %x|#{@command} --full --no-public|
    refute out.empty?, "there should be some output"
    refute_match /\bFoo#public_method\b/, out
    assert_match /\bFoo#protected_method\b/, out
    refute_match /\bFoo#private_method\b/, out # has @private tag
    refute_match /\bFoo#method_with_private_tag\b/, out # has @private tag
  end

  it "should run with --no-public --no-protected switch" do
    out = %x|#{@command} --full --no-public --no-protected|
    assert out.empty?, "there should be no output"
    refute_match /\bFoo#public_method\b/, out
    refute_match /\bFoo#protected_method\b/, out
    refute_match /\bFoo#private_method\b/, out # has @private tag
    refute_match /\bFoo#method_with_private_tag\b/, out # has a @private tag, but is really :public
  end

  it "should run with --no-public --no-protected --private switch" do
    out = %x|#{@command} --full --no-public --no-protected --private|
    refute out.empty?, "there should be some output"
    refute_match /\bFoo#public_method\b/, out
    refute_match /\bFoo#protected_method\b/, out
    assert_match /\bFoo#private_method\b/, out # has @private tag
    refute_match /\bFoo#method_with_private_tag\b/, out # has a @private tag, but is really :public
  end

  it "should run with --no-public --no-private switch" do
    out = %x|#{@command} --full --no-public --no-private|
    refute out.empty?, "there should be some output"
    refute_match /\bFoo#public_method\b/, out
    assert_match /\bFoo#protected_method\b/, out
    refute_match /\bFoo#private_method\b/, out # has @private tag
    refute_match /\bFoo#method_with_private_tag\b/, out # has a @private tag, but is really :public
  end

  it "should run with --no-protected --no-private switch" do
    out = %x|#{@command} --full --no-protected --no-private|
    refute out.empty?, "there should be some output"
    assert_match /\bFoo#public_method\b/, out
    refute_match /\bFoo#protected_method\b/, out
    refute_match /\bFoo#private_method\b/, out # has @private tag
    refute_match /\bFoo#method_with_private_tag\b/, out # has a @private tag, but is really :public
  end
end
