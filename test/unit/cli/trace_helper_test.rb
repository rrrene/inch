require File.expand_path(File.dirname(__FILE__) + '/../../test_helper')

class Tracer
  include ::Inch::CLI::TraceHelper
end

describe ::Inch::CLI::TraceHelper do
  it 'should be a UI instance' do
    @instance = Tracer.new
    assert @instance.ui.is_a?(Inch::Utils::UI)
  end
end
