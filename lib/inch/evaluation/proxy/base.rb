module Inch
  module Evaluation
    module Proxy
      # @abstract
      class Base
        extend Forwardable

        MIN_SCORE = 0
        MAX_SCORE = 100

        TAGGED_SCORE = 20 # assigned per unconsidered tag

        # @return [CodeObject::Proxy::Base]
        attr_accessor :object

        attr_reader :min_score, :max_score

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

        # @param object [CodeObject::Proxy::Base]
        def initialize(object)
          self.object = object
          @roles = []
          evaluate
        end

        # Evaluates the objects and assigns roles
        def evaluate
          __evaluate(object, relevant_roles)
        end

        def __evaluate(object, role_classes)
          role_classes.each do |role_class, score|
            if role_class.applicable?(object)
              add_role role_class.new(object, score)
            end
          end
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

        def criteria
          @criteria ||= begin
            c = self.class.criteria_map[self.class.to_s]
            c.evaluate(object)
            c
          end
        end

        def relevant_base_roles
          {
            Role::Object::InRoot => nil,
            Role::Object::Public => nil,
            Role::Object::Protected => nil,
            Role::Object::Private => nil,
            Role::Object::TaggedAsNodoc => nil,
            Role::Object::WithDoc => score_for(:docstring),
            Role::Object::WithoutDoc => score_for(:docstring),
            Role::Object::WithCodeExample => score_for(:code_example_single),
            Role::Object::WithMultipleCodeExamples => score_for(:code_example_multi),
            Role::Object::WithoutCodeExample => score_for(:code_example_single),
            Role::Object::Tagged => score_for_unconsidered_tags,
            Role::Object::TaggedAsAPI => nil,
            Role::Object::TaggedAsPrivateAPI => nil,
          }
        end

        def score_for_unconsidered_tags
          count = object.unconsidered_tag_count
          score_for(:unconsidered_tag) * count
        end

        # Returns a key-value pair of Role classes and potential scores for
        # each role (can be nil)
        #
        # @return [Hash]
        def relevant_roles
          {}
        end

        def score_for(criteria_name)
          criteria.send(criteria_name) * MAX_SCORE
        end
      end
    end
  end
end
