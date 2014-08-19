module Inch
  module Evaluation
    module Proxy
      # @abstract
      class Base
        extend Forwardable

        MIN_SCORE = 0
        MAX_SCORE = 100

        # @return [CodeObject::Proxy::Base]
        attr_reader :object

        # @return [Array<Evaluation::Role::Base>]
        attr_reader :roles

        # @param object [CodeObject::Proxy::Base]
        def initialize(object)
          @object = object
          @criteria = eval_criteria(Config.for(object.language).evaluation)
          @roles = []
          evaluate
        end

        # Evaluates the objects and assigns roles
        def evaluate
          __evaluate(object, relevant_roles)
        end

        # @return [Float] the max score that is assignable to +object+
        def max_score
          @__max_score = __max_score
        end

        # @return [Float] the min score that is assignable to +object+
        def min_score
          @__min_score = __min_score
        end

        # @return [Fixnum] the final score for +object+
        def score
          @__score ||= __score
        end

        # @return [Fixnum] the priority for +object+
        def priority
          @__priority ||= __priority
        end

        protected

        def add_role(role)
          @roles << role
        end

        def eval_criteria(config)
          object_type = self.class.to_s.split('::').last
          c = config.criteria_for(object_type)
          c.evaluate(object)
          c
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
            Role::Object::WithMultipleCodeExamples =>
              score_for(:code_example_multi),
            Role::Object::WithoutCodeExample => score_for(:code_example_single),
            Role::Object::Tagged => score_for_unconsidered_tags,
            Role::Object::TaggedAsAPI => nil,
            Role::Object::TaggedAsInternalAPI => nil,
            Role::Object::TaggedAsPrivate => nil,
            Role::Object::Alias =>
              if object.alias?
                object.aliased_object.score
              else
                nil
              end
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

        # Returns a score for a given criterion.
        #
        # @param criterion_name [String] e.g. 'docstring' or 'return_type'
        # @return [Float]
        def score_for(criterion_name)
          @criteria.send(criterion_name) * MAX_SCORE
        end

        def __evaluate(object, role_classes)
          role_classes.each do |role_class, score|
            next unless role_class.applicable?(object)
            add_role role_class.new(object, score)
          end
        end

        # @return [Float] the max score that is assignable to +object+
        def __max_score
          arr = @roles.map(&:max_score).compact
          [MAX_SCORE].concat(arr).min
        end

        # @return [Float] the max score that is assignable to +object+
        def __min_score
          arr = @roles.map(&:min_score).compact
          [MIN_SCORE].concat(arr).max
        end

        # @return [Float]
        def __score
          value = @roles.reduce(0) { |sum, r| sum + r.score.to_f }.to_i
          if value < min_score
            min_score
          elsif value > max_score
            max_score
          else
            value
          end
        end

        # @return [Fixnum]
        def __priority
          @roles.reduce(0) { |sum, r| sum + r.priority.to_i }
        end
      end
    end
  end
end
