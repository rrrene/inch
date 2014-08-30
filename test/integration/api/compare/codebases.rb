require File.expand_path(File.dirname(__FILE__) + '/../../../test_helper')

describe ::Inch::API::Compare::Codebases do
  let(:described_class) { ::Inch::API::Compare::Codebases }

  it 'should run' do
    codebase1 = Inch::Codebase.parse fixture_path(:ruby, :diff1)
    codebase2 = Inch::Codebase.parse fixture_path(:ruby, :diff2)

    compare = described_class.new(codebase1, codebase2)
    refute compare.comparisons.empty?

    # Foo#a is added in diff2
    comparison = compare.find('Foo#a')
    assert comparison.added?

    # Foo#b is improved in diff2
    comparison = compare.find('Foo#b')
    assert comparison.present?
    assert comparison.changed?
    assert comparison.improved?

    # Foo#c stayed the same
    comparison = compare.find('Foo#c')
    assert comparison.present?
    assert comparison.unchanged?
    refute comparison.changed?

    # Foo#d is removed in diff2
    comparison = compare.find('Foo#d')
    refute comparison.present?
    assert comparison.removed?
  end
end
