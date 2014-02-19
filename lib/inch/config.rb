module Inch
  # Stores the configuration for Inch
  #
  # @see config/defaults.rb
  class Config
    class << self
      attr_accessor :instance

      def run(&block)
        self.instance ||= new
        instance.update(&block)
        instance
      end
    end

    def update(&block)
      instance_eval(&block)
    end

    def development?
      @development
    end

    def development!
      @development = true
    end

    def evaluation(&block)
      @evaluation ||= Evaluation.new
      @evaluation.update(&block) if block
      @evaluation
    end

    class Evaluation
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
        constant = ::Inch::Evaluation::Proxy.const_get(constant_name)
        constant.criteria(&block)
      end
    end
  end
end
