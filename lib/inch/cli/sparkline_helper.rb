module Inch
  module CLI
    module SparklineHelper
      def ranges_sparkline(_ranges)
        ranges = _ranges.reverse
        list = ranges.map { |r| r.objects.size }
        sparkline = Sparkr::Sparkline.new(list)
        sparkline.format do |tick, count, index|
          t = tick.color(ranges[index].color)
          index == 0 ? t + ' ' : t
        end
      end

      def grades_sparkline(objects)
        grades = {}
        objects.each do |o|
          grades[o.grade] ||= 0
          grades[o.grade] += 1
        end
        ranges = Evaluation.new_score_ranges.reverse
        order = ranges.map(&:grade)
        list = order.map { |g| grades[g] }
        sparkline = Sparkr::Sparkline.new(list)
        sparkline.format do |tick, count, index|
          t = tick.color(ranges[index].color)
          index == 0 ? t + ' ' : t
        end
      end
    end
  end
end
