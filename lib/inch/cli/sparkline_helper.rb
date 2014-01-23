module Inch
  module CLI
    module SparklineHelper
      def ranges_sparkline(ranges)
        list = ranges.reverse.map { |r| r.objects.size }
        sparkline = Sparkr::Sparkline.new(list)
        sparkline.format do |tick, count, index|
          if index == 3 # A
            tick.green
          elsif index == 2 # B
            tick.yellow
          elsif index == 1 # C
            tick.red
          else
            tick.intense_red + ' ' # U
          end
        end
      end
    end
  end
end
