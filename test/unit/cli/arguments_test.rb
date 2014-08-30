require File.expand_path(File.dirname(__FILE__) + '/../../test_helper')

describe ::Inch::CLI::Arguments do
  before do
    Dir.chdir fixture_path(:ruby, :simple)
    assert File.file?('README')
  end

  it 'should run with files' do
    args = [
      'lib/**/*.rb', 'app/**/*.rb', 'README'
    ]
    arguments = ::Inch::CLI::Arguments.new(args)
    assert_equal ['lib/**/*.rb', 'app/**/*.rb', 'README'], arguments.files
    assert_equal [], arguments.object_names
    assert_equal [], arguments.switches
  end

  it 'should run with directories as well' do
    args = [
      'lib', 'app/**/*.rb', 'README'
    ]
    arguments = ::Inch::CLI::Arguments.new(args)
    assert_equal ['lib', 'app/**/*.rb', 'README'], arguments.files
    assert_equal [], arguments.object_names
    assert_equal [], arguments.switches
  end

  it 'should run with files and object_name' do
    args = [
      '{app,lib}.rb', 'README', 'Foo'
    ]
    arguments = ::Inch::CLI::Arguments.new(args)
    assert_equal ['{app,lib}.rb', 'README'], arguments.files
    assert_equal ['Foo'], arguments.object_names
    assert_equal [], arguments.switches
  end

  it 'should run with object_names' do
    args = [
      'Foo::Bar'
    ]
    arguments = ::Inch::CLI::Arguments.new(args)
    assert_equal [], arguments.files, 'files'
    assert_equal ['Foo::Bar'], arguments.object_names
    assert_equal [], arguments.switches
  end

  it 'should run with option switches' do
    args = [
      '--no-color', '--all'
    ]
    arguments = ::Inch::CLI::Arguments.new(args)
    assert_equal [], arguments.files
    assert_equal [], arguments.object_names
    assert_equal ['--no-color', '--all'], arguments.switches
  end

  it 'should run with all of them' do
    args = [
      'lib/**/*.rb', 'app/**/*.rb', 'README',
      'Foo', 'Foo::Bar', '--no-color', '--all'
    ]
    arguments = ::Inch::CLI::Arguments.new(args)
    assert_equal ['lib/**/*.rb', 'app/**/*.rb', 'README'], arguments.files
    assert_equal ['Foo', 'Foo::Bar'], arguments.object_names
    assert_equal ['--no-color', '--all'], arguments.switches
  end

end
