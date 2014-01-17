module Inch
  module Evaluation
    class ScoreRange < Struct.new(:range, :grade, :description, :color)
      # Returns code_objects that received a score with the defined +range+
      attr_accessor :objects
    end

    SCORE_RANGE_ARGS = [
      [80..100, :A, "Seems really good", :green],
      [50...80, :B, "Proper documentation present", :yellow],
      [0...50,  :C, "Needs work", :red],
    ]

    def self.new_score_ranges
      SCORE_RANGE_ARGS.map do |args|
        ScoreRange.new(*args)
      end
    end
  end
end
