require File.expand_path(File.dirname(__FILE__) + '/../../test_helper')

describe ::Inch::Utils::WeightedList do
  before do
    @counts = [4, 8, 8]
  end

  def assert_weighted_list(list, counts, expected)
    weighted_list = ::Inch::Utils::WeightedList.new(list, counts)
    # assert_equal expected.map(&:size).inject(:+),
    #              weighted_list.to_a.map(&:size).inject(:+)
    assert_equal expected, weighted_list.to_a,
                 "should be #{expected.map(&:size)}, was " \
                   "#{weighted_list.to_a.map(&:size)}"
  end

  def list_and_expected(counts, expected_counts)
    elements = [:B, :C, :U]
    list = counts.map.with_index do |num, index|
      (1..num).map { |i| :"#{elements[index]}#{i}" }
    end
    expected = expected_counts.map.with_index do |num, index|
      (1..num).map { |i| :"#{elements[index]}#{i}" }
    end
    [list, expected]
  end

  it 'should work if elements are exact' do
    @list, @expected = list_and_expected([4, 8, 8], [4, 8, 8])
    assert_weighted_list(@list, @counts, @expected)
  end

  it 'should work if more than enough elements are present' do
    @list, @expected = list_and_expected([10, 10, 10], [4, 8, 8])
    assert_weighted_list(@list, @counts, @expected)
  end

  it 'should work if not enough Bs are present' do
    @list, @expected = list_and_expected([2, 12, 15], [2, 8, 10])
    assert_weighted_list(@list, @counts, @expected)
  end

  it 'should work if not enough Cs are present' do
    @list, @expected = list_and_expected([15, 4, 15], [4, 4, 12])
    assert_weighted_list(@list, @counts, @expected)
  end

  it 'should work if not enough Us are present' do
    @list, @expected = list_and_expected([15, 15, 4], [4, 12, 4])
    assert_weighted_list(@list, @counts, @expected)
  end

  it 'should work if not enough Bs AND Cs and Us are present' do
    @list, @expected = list_and_expected([2, 2, 15], [2, 2, 15])
    assert_weighted_list(@list, @counts, @expected)
  end

end
