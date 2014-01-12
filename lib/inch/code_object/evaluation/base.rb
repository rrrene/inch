module Inch
  module CodeObject
    module Evaluation
      class Base
        extend Forwardable

        MAX_SCORE = 100

        attr_accessor :object
        attr_writer :min_score

        def initialize(object)
          self.object = object
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

        protected

        def add_score(points)
          @score = @score.to_i + points
        end
        
        def min_score
          @min_score.to_i
        end

        def max_score
          MAX_SCORE
        end
      end
    end
  end
end
