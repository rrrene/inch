module Inch
  module CLI
    module SparklineHelper
      def grade_lists_sparkline(grade_lists)
        new_grade_lists = grade_lists.reverse
        list = new_grade_lists.map { |r| r.objects.size }
        __sparkline(list, new_grade_lists)
      end

      def grades_sparkline(objects)
        grades = {}
        objects.each do |o|
          grades[o.grade.to_sym] ||= 0
          grades[o.grade.to_sym] += 1
        end
        grade_lists = Evaluation.new_grade_lists.reverse
        order = grade_lists.map(&:to_sym)
        list = order.map { |g| grades[g] }
        __sparkline(list, grade_lists)
      end

      def __sparkline(list, grade_lists)
        sparkline = Sparkr::Sparkline.new(list)
        sparkline.format do |tick, _count, index|
          t = tick.color(grade_lists[index].color)
          index == 0 ? t + ' ' : t
        end
      end
    end
  end
end
