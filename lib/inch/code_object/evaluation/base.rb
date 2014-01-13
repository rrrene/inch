module Inch
  module CodeObject
    module Evaluation
      class Base
        extend Forwardable

        MAX_SCORE = 100

        attr_accessor :object
        attr_reader :min_score, :max_score

        def initialize(object)
          self.object = object
          @min_score = 0
          @scores = []
          set_max_score(MAX_SCORE)
          evaluate
        end

        def evaluate
        end

        def score
          if @score.to_i < min_score
            min_score
          elsif @score.to_i > max_score
            max_score
          else
            @score.to_i
          end
        end

        # Sets the max_score.
        # Can only be decreased to create an upper bound for evaluation.
        def max_score=(val)
          if val < @max_score
            @max_score = val
          end
        end

        protected

        def add_score(score_object)
          @scores << score_object
          @score = @score.to_f + score_object.to_f
        end
        
        def min_score
          @min_score.to_i
        end

        def set_max_score(default)
          @max_score = default
        end
      end
    end
  end
end
