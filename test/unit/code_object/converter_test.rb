require File.expand_path(File.dirname(__FILE__) + '/../../test_helper')

describe ::Inch::CodeObject::Converter do
  class MockObject
    def docstring
      'Foo::Bar'
    end

    def parameters
      []
    end

    def public?
      false
    end

    def private?
      true
    end
  end

  let(:object) { MockObject.new }
  it 'should parse all objects' do
    attributes = ::Inch::CodeObject::Converter.to_hash(object)
    assert_equal object.docstring, attributes[:docstring]
    assert_equal object.public?, attributes[:public?]
    assert_equal object.private?, attributes[:private?]
  end
end
