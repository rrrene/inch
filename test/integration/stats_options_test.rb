require File.expand_path(File.dirname(__FILE__) + '/../test_helper')

#
# These format tests also broke things in the regular testsuite.
# See ./list_options_test.rb
#
# Therefore, here are some integration tests:
#
describe ::Inch::CLI::Command::List do
  before do
    Dir.chdir fixture_path(:ruby, :simple)
    @command = 'bundle exec inch stats'
  end

  def assert_parsed_output(parsed)
    assert parsed.size > 0
    assert parsed['grade_lists']
    assert parsed['scores']
    assert parsed['priorities']
  end

  it 'should run with --no-private switch' do
    out = `#{@command} --format json`
    refute out.empty?, 'there should be some output'
    assert_parsed_output JSON[out]
  end

  it 'should run with --no-protected switch' do
    out = `#{@command} --format yaml`
    refute out.empty?, 'there should be some output'
    assert_parsed_output YAML.load(out)
  end

end
