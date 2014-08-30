require File.expand_path(File.dirname(__FILE__) + '/../../test_helper')
require 'inch/utils/buffered_ui'

describe ::Inch::Utils::BufferedUI do
  let(:described_class) { ::Inch::Utils::BufferedUI }
  it 'should trace' do
    out, err = capture_io do
      @instance = described_class.new
      @instance.trace('Test')
    end
    assert out.empty?, 'there should be output'
    assert err.empty?, 'there should be no errors'
    refute @instance.buffer.empty?
  end

  it 'should trace header' do
    out, err = capture_io do
      @instance = described_class.new
      @instance.header('Test', :red)
    end
    assert out.empty?, 'there should be output'
    assert err.empty?, 'there should be no errors'
    refute @instance.buffer.empty?
  end

  it 'should trace debug if ENV variable is set' do
    ENV['DEBUG'] = '1'
    out, err = capture_io do
      @instance = described_class.new
      @instance.debug('Test')
    end
    ENV['DEBUG'] = nil
    assert out.empty?, 'there should be output'
    assert err.empty?, 'there should be no errors'
    refute @instance.buffer.empty?
  end

  it 'should not trace debug if ENV variable is set' do
    refute ENV['DEBUG']
    out, err = capture_io do
      @instance = described_class.new
      @instance.debug('Test')
    end
    assert out.empty?, 'there should be no output'
    assert err.empty?, 'there should be no errors'
    assert @instance.buffer.empty?
  end
end
