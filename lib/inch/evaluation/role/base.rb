module Inch
  module Evaluation
    module Role
      class Base
        def initialize(object, value = nil)
          @object = object
          @value = value
        end
        
        # Override this method to that a max_score for the evaluation.
        def max_score
        end

        # Override this method to that a min_score for the evaluation.
        def min_score
        end

        # Returns a score that will be added to the associated object's
        # overall score.
        #
        # Override this method to that a score for the role.
        def score
          @value.to_f
        end

        def priority
          0
        end
      end
    end
  end
end
