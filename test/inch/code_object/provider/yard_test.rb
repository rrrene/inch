require File.expand_path(File.dirname(__FILE__) + '/../../../test_helper')

describe ::Inch::CodeObject::Provider::YARD do
  let(:described_class) { ::Inch::CodeObject::Provider::YARD }

  it "should parse" do
    provider = described_class.parse(fixture_path(:simple), ["lib/**/*.rb"], [])
    assert !provider.objects.empty?
  end

end