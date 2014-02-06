module Inch
  module Evaluation
    # ScoreRange objects associate a range of scores with a grade,
    # description, color etc.
    #
    # @see .new_score_ranges
    class ScoreRange < Struct.new(:range, :grade, :description, :color, :bg_color)
      # Returns code_objects that received a score with the defined +range+
      attr_reader :objects

      # Assigns code_objects that received a score with the defined +range+
      #
      # @param arr [Array<CodeObject::Proxy::Base>]
      # @return [Array<CodeObject::Proxy::Base>]
      def objects=(arr)
        arr.each { |o| o.grade = grade }
        @objects = arr
      end
    end

    # Returns newly instanciated score range objects based on
    # {SCORE_RANGE_ARGS}
    #
    # @return [Array<ScoreRange>]
    def self.new_score_ranges
      grades = Evaluation::Grade.grade_map.values
      grades.map do |g|
        ScoreRange.new(g.scores, g.to_sym, g.label, g.color, g.bg_color)
      end
    end
  end
end
