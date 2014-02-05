module Inch
  module Evaluation
    class Criteria
      attr_reader :object

      def initialize(&block)
        @block = block
      end

      def evaluate(object)
        @object = object
        instance_eval(&@block)
      end

      NAMES = %w(
        docstring
        parameters
        return_type
        return_description
        code_example_single
        code_example_multi
        unconsidered_tag
        )

      NAMES.each do |name|
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
    end
  end
end
