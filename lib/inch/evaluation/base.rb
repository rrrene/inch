module Inch
  module Evaluation
    # @abstract
    class Base
      extend Forwardable

      MIN_SCORE = 0
      MAX_SCORE = 100

      TAGGED_SCORE = 20 # assigned per unconsidered tag


      attr_accessor :object
      attr_reader :min_score, :max_score

      def initialize(object)
        self.object = object
        @roles = []
        evaluate
      end

      def evaluate
      end

      def max_score
        arr = @roles.map(&:max_score).compact
        [MAX_SCORE].concat(arr).min
      end

      def min_score
        arr = @roles.map(&:min_score).compact
        [MIN_SCORE].concat(arr).max
      end

      def score
        value = @roles.inject(0) { |sum,r| sum + r.score.to_f }
        if value < min_score
          min_score
        elsif value > max_score
          max_score
        else
          value
        end
      end

      def priority
        @roles.inject(0) { |sum,r| sum + r.priority.to_i }
      end

      def roles
        @roles
      end

      protected

      def add_role(role)
        @roles << role
      end
    end
  end
end
