require 'inch/code_object/converter'

module Inch
  module Codebase
    # An object that holds a code_object as well as it's evaluation
    # and exposes shortcut methods to the commonly asked members of
    # both.
    class Object
      extend Forwardable

      attr_reader :code_object

      # @return [String]
      attr_reader :language

      # @return [Grade]
      #   when objects are assigned to GradeLists, this grade is set to
      #   enable easier querying for objects of a certain grade
      attr_writer :grade

      # convenient shortcuts to evalution object
      def_delegators :evaluation, :score, :roles, :priority

      # convenient shortcuts to code object
      def_delegators :code_object, :object_lookup=

      # @param language [String,Symbol]
      # @param code_object [YARD::Object::Base]
      # @param object_lookup [Codebase::Objects]
      def initialize(language, code_object, object_lookup)
        @language = language
        @code_object = CodeObject::Proxy.for(language, code_object,
                                             object_lookup)
      end

      def evaluation
        @evaluation ||= Evaluation::Proxy.for(@language, self)
      end

      # @return [Grade]
      def grade
        @grade ||= Evaluation.new_grade_lists.find do |range|
          range.scores.include?(score)
        end.grade
      end

      def method_missing(name, *args, &block)
        if code_object.respond_to?(name)
          self.class.class_eval <<-RUBY
            def #{name}(*args, &block)
              code_object.#{name}(*args, &block)
            end
          RUBY
          code_object.send(name, *args, &block)
        else
          super
        end
      end
    end
  end
end
