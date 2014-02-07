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

      class << self
        attr_reader :criteria_map

        # Defines the weights during evaluation for different criteria
        #
        #   MethodObject.criteria do
        #     docstring           0.5
        #     parameters          0.4
        #     return_type         0.1
        #
        #     if object.constructor?
        #       parameters        0.5
        #       return_type       0.0
        #     end
        #   end
        #
        # @return [void]
        def criteria(&block)
          @criteria_map ||= {}
          @criteria_map[to_s] ||= ObjectSchema.new(&block)
        end
      end

      protected

      def add_role(role)
        @roles << role
      end

      def criteria
        @criteria ||= begin
          c = self.class.criteria_map[self.class.to_s]
          c.evaluate(object)
          c
        end
      end

      def eval_visibility
        if object.in_root?
          add_role Role::Object::InRoot.new(object)
        end
        if object.public?
          add_role Role::Object::Public.new(object)
        end
        if object.protected?
          add_role Role::Object::Protected.new(object)
        end
        if object.private?
          add_role Role::Object::Private.new(object)
        end
      end

      def eval_doc
        if object.has_doc?
          add_role Role::Object::WithDoc.new(object, score_for(:docstring))
        else
          add_role Role::Object::WithoutDoc.new(object, score_for(:docstring))
        end
        if object.nodoc?
          add_role Role::Object::TaggedAsNodoc.new(object)
        end
      end

      def eval_code_example
        if object.has_code_example?
          if object.has_multiple_code_examples?
            add_role Role::Object::WithMultipleCodeExamples.new(object, score_for(:code_example_multi))
          else
            add_role Role::Object::WithCodeExample.new(object, score_for(:code_example_single))
          end
        else
          add_role Role::Object::WithoutCodeExample.new(object, score_for(:code_example_single))
        end
      end

      def eval_tags
        if object.api_tag?
          if object.private_api_tag?
            add_role Role::Object::TaggedAsPrivateAPI.new(object)
          else
            add_role Role::Object::TaggedAsAPI.new(object)
          end
        end
        if object.has_unconsidered_tags?
          count = object.unconsidered_tags.size
          add_role Role::Object::Tagged.new(object, score_for(:unconsidered_tag) * count)
        end
      end

      def score_for(criteria_name)
        criteria.send(criteria_name) * MAX_SCORE
      end
    end
  end
end
