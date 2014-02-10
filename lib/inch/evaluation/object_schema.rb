module Inch
  module Evaluation
    class ObjectSchema
      extend Utils::ReadWriteMethods

      rw_methods %w(
        docstring
        parameters
        return_type
        return_description
        code_example_single
        code_example_multi
        unconsidered_tag
        )

      attr_reader :object

      def initialize(&block)
        @block = block
      end

      def evaluate(object)
        @object = object
        instance_eval(&@block)
      end
    end
  end
end
