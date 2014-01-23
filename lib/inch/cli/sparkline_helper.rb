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

      def grades_sparkline(objects)
        grades = {}
        objects.each do |o|
          grades[o.grade] ||= 0
          grades[o.grade] += 1
        end
        order = [:U, :C, :B, :A]
        list = order.map { |g| grades[g] }
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
