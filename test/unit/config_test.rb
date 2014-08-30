require File.expand_path(File.dirname(__FILE__) + '/../test_helper')

describe ::Inch::Config do
  it 'should return config for :ruby' do
    config = Inch::Config.for(:ruby)
    refute config.codebase.included_files.empty?
    assert config.codebase.excluded_files.empty?
  end

  it 'should parse .inch.yml if present' do
    dir = fixture_path(:ruby, :"inch-yml")
    config = Inch::Config.for(:ruby, dir)
    refute config.codebase.included_files.empty?
    refute config.codebase.excluded_files.empty?

    # Assert that this is another conf, unaltered
    # by the conf loading before
    config = Inch::Config.for(:ruby)
    refute config.codebase.included_files.empty?
    assert config.codebase.excluded_files.empty?
  end

  it 'should return config.evaluation for :ruby' do
    config = Inch::Config.for(:ruby)
    refute_nil config.evaluation.criteria_for(:MethodObject)
  end

end
