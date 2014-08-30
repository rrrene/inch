require 'inch/evaluation/proxy'

module Inch
  module API
    module Options
      class Suggest < Base
        # This module is included here and in Command::Options::Suggest
        # to ensure the same default values for the command-line and library
        # interface
        module DefaultAttributeValues
          DEFAULT_OBJECT_COUNT        = 20
          DEFAULT_FILE_COUNT          = 5
          DEFAULT_PROPER_GRADES       = [:A, :B]
          DEFAULT_GRADES_TO_DISPLAY   = [:B, :C, :U]
          DEFAULT_GRADE_WEIGHTS       = [0.2, 0.4, 0.4]
          DEFAULT_OBJECT_MIN_PRIORITY = 0
          DEFAULT_OBJECT_MAX_SCORE    = ::Inch::Evaluation::Proxy::MAX_SCORE
        end

        include DefaultAttributeValues

        attribute :object_count, DEFAULT_OBJECT_COUNT
        attribute :file_count, DEFAULT_FILE_COUNT
        attribute :proper_grades, DEFAULT_PROPER_GRADES
        attribute :grades_to_display, DEFAULT_GRADES_TO_DISPLAY
        attribute :grade_weights, DEFAULT_GRADE_WEIGHTS
        attribute :object_min_priority, DEFAULT_OBJECT_MIN_PRIORITY
        attribute :object_max_score, DEFAULT_OBJECT_MAX_SCORE
      end
    end
  end
end
