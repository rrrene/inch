require File.expand_path(File.dirname(__FILE__) + '/../../../../test_helper')

describe ::Inch::Language::Ruby::Provider::YARD do
  let(:described_class) { ::Inch::Language::Ruby::Provider::YARD }
  let(:config) { ::Inch::Config.codebase }

  it 'should parse' do
    provider = described_class.parse(fixture_path(:ruby, :simple), config)
    assert !provider.objects.empty?
  end

  it 'should parse too different codebases' do
    fullname = 'Foo#b'

    provider1 = described_class.parse(fixture_path(:ruby, :diff1), config)
    object1 = provider1.objects.find { |o| o.fullname == fullname }

    provider2 = described_class.parse(fixture_path(:ruby, :diff2), config)
    object2 = provider2.objects.find { |o| o.fullname == fullname }

    refute object1.nil?
    refute object2.nil?
    assert object1.object_id != object2.object_id
  end
end
