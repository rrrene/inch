module Inch
  # The Evaluation module concerns itself with the evaluation of code objects
  # with regard to their inline code documentation
  module Evaluation
    module Proxy
      # Returns a Proxy object for the given +code_object+
      #
      # @param language [String,Symbol]
      # @param object [Codebase::Object]
      # @return [Evaluation::Proxy]
      def self.for(language, object)
        class_for(language, object.code_object).new(object)
      end

      extend Forwardable

      MIN_SCORE = 0
      MAX_SCORE = 100

      # @return [CodeObject::Proxy]
      attr_reader :object

      # @return [Array<Evaluation::Role::Base>]
      attr_reader :roles

      # @param object [CodeObject::Proxy]
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

      # Returns a key-value pair of Role classes and potential scores for
      # each role (can be nil)
      #
      # @see #evaluate
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

      private

      def self.class_for(language, code_object)
        class_name = code_object.class.to_s.split("::").last
        language_namespace = Evaluation::Ruby
        language_namespace.const_get(class_name)
      end
    end
  end
end

require "inch/evaluation/ruby/base"
require "inch/evaluation/ruby/namespace_object"
require "inch/evaluation/ruby/class_object"
require "inch/evaluation/ruby/class_variable_object"
require "inch/evaluation/ruby/constant_object"
require "inch/evaluation/ruby/method_object"
require "inch/evaluation/ruby/module_object"
