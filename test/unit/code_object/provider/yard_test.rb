require File.expand_path(File.dirname(__FILE__) + '/../../../test_helper')

describe ::Inch::CodeObject::Provider::YARD do
  let(:described_class) { ::Inch::CodeObject::Provider::YARD }

  it "should parse" do
    provider = described_class.parse(fixture_path(:simple))
    assert !provider.objects.empty?
  end

  it "should parse too different codebases" do
    fullname = "Foo#b"

    provider1 = described_class.parse(fixture_path(:diff1))
    object1 = provider1.objects.detect { |o| o.fullname == fullname }

    provider2 = described_class.parse(fixture_path(:diff2))
    object2 = provider2.objects.detect { |o| o.fullname == fullname }

    refute object1.nil?
    refute object2.nil?
    assert object1.object_id != object2.object_id
  end

end