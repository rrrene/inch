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

        # Override this method to that a score for the role.
        def score
          @value.to_f
        end
      end
    end
  end
end
