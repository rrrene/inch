require File.expand_path(File.dirname(__FILE__) + '/../../test_helper')

describe ::Inch::Config::Codebase do
  it 'should parse .inch.yml' do
    dir = fixture_path(:ruby, :simple)
    config = Inch::Config::Codebase.new
    config.update_via_yaml(dir)
    assert config.included_files.empty?
    assert config.excluded_files.empty?
  end

  it 'should parse .inch.yml if present' do
    dir = fixture_path(:ruby, :"inch-yml")
    config = Inch::Config::Codebase.new
    config.update_via_yaml(dir)
    refute config.included_files.empty?
    refute config.excluded_files.empty?
  end
end
