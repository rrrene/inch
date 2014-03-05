require File.expand_path(File.dirname(__FILE__) + '/../../test_helper')

describe ::Inch::Config::Codebase do
  it "should parse .inch.yml" do
    dir = fixture_path(:simple)
    config = Inch::Config::Codebase.new
    config.update_via_yaml(dir)
    assert config.included_files.empty?
    assert config.excluded_files.empty?
  end

  it "should parse .inch.yml" do
    dir = fixture_path(:"inch-yml")
    config = Inch::Config::Codebase.new
    config.update_via_yaml(dir)
    refute config.included_files.empty?
    refute config.excluded_files.empty?
  end
end
