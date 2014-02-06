module Inch
  module Evaluation
    class Grade
      extend Evaluation::ReadWriteMethods

      rw_methods %w(scores label color bg_color)

      def initialize(symbol)
        @symbol = symbol
      end

      def update(&block)
        instance_eval(&block)
      end

      def to_sym
        @symbol
      end

      class << self
        attr_reader :grade_map

        def grade(symbol, &block)
          @grade_map ||= {}
          @grade_map[symbol] ||= Grade.new(symbol)
          @grade_map[symbol].update(&block) if block
          @grade_map[symbol]
        end
      end
    end
  end
end
