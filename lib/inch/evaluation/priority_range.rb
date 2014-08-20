module Inch
  module Evaluation
    # PriorityRange objects are used to associate a given
    # range of priorities with a symbol and an arrow.
    #
    class PriorityRange
      extend Utils::ReadWriteMethods
      extend Forwardable

      rw_methods %w(priorities arrow)

      def_delegators :priorities, :include?, :min, :max

      def initialize(symbol)
        @symbol = symbol
      end

      def update(&block)
        instance_eval(&block)
      end

      def to_sym
        @symbol
      end

      def to_s
        arrow
      end

      class << self
        attr_reader :priority_map

        def all
          @priority_map ||= {}
          @priority_map.values
        end

        def priority_range(symbol, &block)
          @priority_map ||= {}
          @priority_map[symbol] ||= PriorityRange.new(symbol)
          @priority_map[symbol].update(&block) if block
          @priority_map[symbol]
        end
      end
    end
  end
end
