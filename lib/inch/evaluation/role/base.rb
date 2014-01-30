module Inch
  module Evaluation
    module Role
      # @abstract
      class Base
        attr_reader :object

        def initialize(object, value = nil)
          @object = object
          @value = value
        end

        # @note Override this method to that a max_score for the evaluation.
        def max_score
        end

        # @note Override this method to that a min_score for the evaluation.
        def min_score
        end

        # Returns a score that will be added to the associated object's
        # overall score.
        #
        # @note Override this method to assign a score for the role
        def score
          @value.to_f
        end

        # @return [Float]
        #  a score that can be achieved by adding the missing thing mentioned
        #  by the role
        def potential_score
          nil
        end

        # Returns a priority that will be added to the associated object's
        # overall priority.
        #
        # @note Override this method to assign a priority for the role
        def priority
          0
        end

        def suggestion
          nil
        end

        def object_type
          object.class.to_s.split('::').last.gsub(/Object$/, '').downcase
        end
      end
    end
  end
end
