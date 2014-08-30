require File.expand_path(File.dirname(__FILE__) + '/../../test_helper')

class MockPrivateRole < ::Inch::Evaluation::Role
  applicable_if :private?
end

class MockNotPrivateRole < ::Inch::Evaluation::Role
  applicable_unless :private?
end

class MockPublicRole < ::Inch::Evaluation::Role
  applicable_if { |o| o.public? }
end

class MockIndifferentRole < ::Inch::Evaluation::Role
  def self.applicable?(_object)
    true
  end
end

class MockPrivateObject
  def private?
    true
  end

  def public?
    false
  end
end

class MockPublicObject
  def private?
    false
  end

  def public?
    true
  end
end

describe ::Inch::Evaluation::Role do
  describe '.applicable' do
    let(:private_object) { MockPrivateObject.new }
    let(:public_object) { MockPublicObject.new }

    describe '.applicable_if' do
      it 'should work with a symbol' do
        assert MockPrivateRole.applicable?(private_object)
        assert !MockPrivateRole.applicable?(public_object)
      end

      it 'should work with a block' do
        assert MockPublicRole.applicable?(public_object)
        assert MockNotPrivateRole.applicable?(public_object)
        assert !MockPublicRole.applicable?(private_object)
      end
    end

    describe '.applicable_unless' do
      it 'should work with a block' do
        assert MockNotPrivateRole.applicable?(public_object)
        assert !MockNotPrivateRole.applicable?(private_object)
      end
    end

    it 'should work by implementing a class method' do
      assert MockIndifferentRole.applicable?(private_object)
      assert MockIndifferentRole.applicable?(public_object)
    end
  end
end
