module Inch
  module Evaluation
    # @abstract
    class Base
      extend Forwardable

      MIN_SCORE = 0
      MAX_SCORE = 100

      TAGGED_SCORE = 20 # assigned per unconsidered tag

      # @return [CodeObject::Proxy::Base]
      attr_accessor :object
      
      attr_reader :min_score, :max_score

      # @param object [CodeObject::Proxy::Base]
      def initialize(object)
        self.object = object
        @roles = []
        evaluate
      end

      # Evaluates the objects and assigns roles
      # @abstract
      def evaluate
      end

      # @return [Float]
      def max_score
        arr = @roles.map(&:max_score).compact
        [MAX_SCORE].concat(arr).min
      end

      # @return [Float]
      def min_score
        arr = @roles.map(&:min_score).compact
        [MIN_SCORE].concat(arr).max
      end

      # @return [Float]
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

      # @return [Fixnum]
      def priority
        @roles.inject(0) { |sum,r| sum + r.priority.to_i }
      end

      # @return [Array<Evaluation::Role::Base>]
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
