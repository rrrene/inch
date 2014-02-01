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

    SCORE_RANGE_ARGS = [
      [80..100, :A, "Seems really good", :green],
      [50...80, :B, "Proper documentation present", :yellow],
      [1...50,  :C, "Needs work", :red],
      [0..0,    :U, "Undocumented", :color141, :color105],
    ]

    # Returns newly instanciated score range objects based on 
    # {SCORE_RANGE_ARGS}
    #
    # @return [Array<ScoreRange>]
    def self.new_score_ranges
      SCORE_RANGE_ARGS.map do |args|
        ScoreRange.new(*args)
      end
    end
  end
end
