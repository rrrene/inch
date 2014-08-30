require File.expand_path(File.dirname(__FILE__) + '/../../../test_helper')

class Inch::CLI::Command::Output::Console
  def run_pry
    nil # instead of binding.pry
  end
end

describe ::Inch::CLI::Command::Console do
  before do
    Dir.chdir fixture_path(:ruby, :simple)
    @command = ::Inch::CLI::Command::Console
  end

  it 'should output info when run with --help' do
    out, err = capture_io do
      assert_raises(SystemExit) { @command.run('--help') }
    end
    refute out.empty?, 'there should be some output'
    assert_match(/\bUsage\b.+console/, out)
    assert err.empty?, 'there should be no errors'
  end

  it 'should run without args' do
    _out, _err = capture_io do
      @prompt = @command.new.run
    end
    assert @prompt.respond_to?(:all)
    assert @prompt.respond_to?(:ff)
    assert @prompt.respond_to?(:f)
    assert @prompt.respond_to?(:o)
    assert @prompt.o.nil?
    assert @prompt.objects.empty?
  end

  it 'should run with a definitive object name' do
    _out, _err = capture_io do
      @prompt = @command.new.run('Foo::Bar#method_with_full_doc')
    end
    assert !@prompt.all.empty?
    assert !@prompt.ff('Foo::Bar#').empty?
    assert !@prompt.f('Foo::Bar').nil?
    assert !@prompt.o.nil?
    refute @prompt.o.nil?
    assert_equal 1, @prompt.objects.size
  end

  it 'should run with a partial name' do
    _out, _err = capture_io do
      @prompt = @command.new.run('Foo::Bar#')
    end
    assert @prompt.respond_to?(:all)
    assert @prompt.respond_to?(:ff)
    assert @prompt.respond_to?(:f)
    assert @prompt.respond_to?(:o)
    refute @prompt.o.nil?
    assert @prompt.objects.size > 1
  end
end
