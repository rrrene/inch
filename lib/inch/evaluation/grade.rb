module Inch
  module Evaluation
    # Grades are human-friendly representations of scores.
    #
    class Grade
      extend Utils::ReadWriteMethods

      rw_methods %w(scores label color bg_color)

      def initialize(symbol)
        @symbol = symbol
      end

      # Updates the grade's configuration with the given block
      #
      # @param block [Proc]
      # @return [void]
      def update(&block)
        instance_eval(&block)
      end

      # @return [Symbol] the grade as a symbol (e.g. +:A+)
      def to_sym
        @symbol
      end

      # @return [String] the grade as a string (e.g. "A")
      def to_s
        @symbol.to_s
      end

      class << self
        attr_reader :grade_map

        def all
          @grade_map ||= {}
          @grade_map.values
        end

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
