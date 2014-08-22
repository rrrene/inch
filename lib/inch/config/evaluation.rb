module Inch
  class Config
    class Evaluation
      def initialize(language)
        @language = language
        @criteria_blocks = {}
      end

      def update(&block)
        instance_eval(&block)
      end

      def grade(symbol, &block)
        ::Inch::Evaluation::Grade.grade(symbol, &block)
      end

      def priority(symbol, &block)
        ::Inch::Evaluation::PriorityRange.priority_range(symbol, &block)
      end

      def schema(constant_name, &block)
        @criteria_blocks[constant_name.to_s] = Criteria.new(&block)
      end

      def criteria_for(constant_name)
        @criteria_blocks[constant_name.to_s]
      end

      # An Criteria describes how important certain parts of the docs are
      # for the associated Object
      class Criteria
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
          # we are "deleting" the block/Proc here because it can't be
          # serialized by Marshal
          # TODO: find a nicer way to achieve this
          @block = nil
        end
      end
    end
  end
end
