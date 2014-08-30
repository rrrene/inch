require File.expand_path(File.dirname(__FILE__) + '/../../test_helper')

describe ::Inch::Utils::UI do
  it 'should trace' do
    out, err = capture_io do
      @instance = ::Inch::Utils::UI.new
      @instance.trace('Test')
    end
    refute out.empty?, 'there should be output'
    assert err.empty?, 'there should be no errors'
  end

  it 'should trace header' do
    out, err = capture_io do
      @instance = ::Inch::Utils::UI.new
      @instance.header('Test', :red)
    end
    refute out.empty?, 'there should be output'
    assert err.empty?, 'there should be no errors'
  end

  it 'should trace debug if ENV variable is set' do
    ENV['DEBUG'] = '1'
    out, err = capture_io do
      @instance = ::Inch::Utils::UI.new
      @instance.debug('Test')
    end
    ENV['DEBUG'] = nil
    refute out.empty?, 'there should be output'
    assert err.empty?, 'there should be no errors'
  end

  it 'should not trace debug if ENV variable is set' do
    refute ENV['DEBUG']
    out, err = capture_io do
      @instance = ::Inch::Utils::UI.new
      @instance.debug('Test')
    end
    assert out.empty?, 'there should be no output'
    assert err.empty?, 'there should be no errors'
  end
end
