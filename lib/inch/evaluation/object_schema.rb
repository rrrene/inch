module Inch
  module Evaluation
    class ObjectSchema
      attr_reader :object

      def initialize(&block)
        @block = block
      end

      def evaluate(object)
        @object = object
        instance_eval(&@block)
      end

      def self.rw_method(name)
        class_eval """
          def #{name}(value = nil)
            if value.nil?
              @#{name}.to_f
            else
              @#{name} = value
            end
          end
        """
      end

      def self.rw_methods(*names)
        [names].flatten.each { |name| rw_method(name) }
      end

      rw_methods %w(
        docstring
        parameters
        return_type
        return_description
        code_example_single
        code_example_multi
        unconsidered_tag
        )
    end
  end
end
