module Inch
  module CLI
    module Command
      module Output
        class Stats < Base
          attr_reader :objects, :good_percent

          def initialize(options, objects, ranges, good_percent)
            @options = options
            @objects = objects
            @ranges = ranges
            @good_percent = good_percent

            display_stats
          end

          private

          def display_stats
            all_size = objects.size
            @ranges.each do |range|
              size = range.objects.size
              percent = all_size > 0 ? ((size/all_size.to_f) * 100).to_i : 0
              trace "#{size.to_s.rjust(5)} objects #{percent.to_s.rjust(3)}%  #{range.description}".method("#{range.color}").call
            end
            trace "".ljust(14) + "#{good_percent.to_s.rjust(3)}% seem good."
          end

        end
      end
    end
  end
end
