module Inch
  module API
    # Filters a codebase's objects based on given options
    class Filter
      attr_reader :codebase
      attr_reader :objects

      def initialize(codebase, options)
        @codebase = codebase
        codebase.objects.filter! Options::Filter.new(options)
        @objects = codebase.objects.to_a
      end

      def grade_lists(_objects = objects)
        lists = Evaluation.new_grade_lists
        lists.each do |range|
          list = _objects.select { |o| range.scores.include?(o.score) }
          range.objects = Codebase::Objects.sort_by_priority(list)
        end
        lists
      end
    end
  end
end
