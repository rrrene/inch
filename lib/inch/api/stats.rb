module Inch
  module API
    class Stats < Filter
      # Returns a hash with priority ranges and associated objects
      # @return [Hash]
      def objects_by_priority_ranges
        hash = {}
        PRIORITY_MAP.each do |priority_range, arrow|
          hash[priority_range] = objects.select do |o|
            priority_range.include?(o.priority)
          end
        end
        hash
      end
    end
  end
end
