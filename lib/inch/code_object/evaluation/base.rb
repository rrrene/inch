module Inch
  module CodeObject
    module Evaluation
      class Base
        extend Forwardable
        
        MIN_SCORE = 0
        MAX_SCORE = 100

        attr_accessor :object
        attr_reader :min_score, :max_score

        def initialize(object)
          self.object = object
          @scores = []
          set_min_score(MIN_SCORE)
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

        # Sets the min_score.
        # Can only be increased to create a lower bound for evaluation.
        def min_score=(val)
          if val > @min_score
            @min_score = val
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

        def set_min_score(default)
          @min_score = default
        end

        def set_max_score(default)
          @max_score = default
        end
      end
    end
  end
end
