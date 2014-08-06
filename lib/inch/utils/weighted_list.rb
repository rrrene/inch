module Inch
  module Utils
    class WeightedList
      # Trims down a list of object lists to given sizes.
      # If there are not enough objects in any particular tier,
      # they are filled up from the tier below/above.
      #
      # @example
      #
      #   list = [
      #     [:B1, :B2],
      #     [:C1, :C2, :C3, :C4, :C5, :C6, :C7, :C8, :C9, :C10],
      #     [:U1, :U2, :U3, :U4, :U5, :U6, :U7, :U8, :U9, :U10]
      #   ]
      #   counts = [4, 8, 8]
      #
      # This means there should be 4 +:B+s, 8 +:C+s, and 8 +:U+s in the
      # resulting list. But we only have 2 +:B+s, so the result is filled up
      # with +:U+s:
      #
      #   WeightedList.new(list, counts).to_a
      #   # => [
      #       [:B1, :B2],
      #       [:C1, :C2, :C3, :C4, :C5, :C6, :C7, :C8],
      #       [:U1, :U2, :U3, :U4, :U5, :U6, :U7, :U8, :U9, :U10]
      #     ]
      #
      # @param list_of_lists [Array<Array>]
      # @param counts [Array<Fixnum>]
      def initialize(list_of_lists, counts)
        @original = list_of_lists
        @max_counts = counts
        compute_list
      end

      # @return [Array]
      def to_a
        @list
      end

      private

      def compute_list
        @list = init_empty_list(@original.size)
        still_missing = fill_list_with_predefined_sizes

        # all sublists are now filled up to their max capacity but we might
        # have missed some objects (+still_missing+), because there weren't
        # enough

        @original.reverse_each.with_index do |sublist, rear_index|
          if still_missing > 0
            index = @original.size - rear_index - 1
            present_count = @max_counts[index]
            not_yet_in_list = sublist[present_count..-1]
            if not_yet_in_list
              put_in_list = not_yet_in_list[0...still_missing]
              @list[index].concat put_in_list
              still_missing -= put_in_list.size
            end
          end
        end
      end

      def init_empty_list(sublist_count)
        list = []
        sublist_count.times { list << [] }
        list
      end

      def fill_list_with_predefined_sizes
        missing = 0
        @original.each_with_index do |sublist, index|
          target_count = @max_counts[index]
          @list[index].concat sublist[0...target_count]

          next unless sublist.size < target_count
          missing += target_count - sublist.size
        end
        missing
      end
    end
  end
end
