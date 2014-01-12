module Inch
  # The OutputHelper module provides helper methods to output information
  # to STDOUT.
  module TraceHelper

    # Puts the given arguments
    #
    def trace(*args)
      puts *args
    end

    # Traces the result of the given block if Inch is running in verbose mode
    #
    # Example:
    #   verbose { "Debug information: " + some_expensive_lookup.to_s }
    #
    def verbose(&block)
      if Inch.verbose
        trace block.()
      end
    end

    # Traces the result of the given block if warnings are enabled
    #
    # Example:
    #   warning { "This might cause problems: " + something.to_s }
    #
    def warning(&block)
      if Inch.warnings
        trace TraceInfo.new("WARNING", block.().to_s, :yellow)
      end
    end

    class TraceInfo
      COL_LENGTH = 20

      def initialize(left, right, color = nil)
        @left, @right, @color = left, right, color
      end

      def left
        l = (@left.to_s + " ").rjust(COL_LENGTH)
        l = l.__send__(@color) if @color
        l.bold
      end

      def right
        r = @right.to_s
        r = r.__send__(@color) if @color
        r
      end

      def to_s
        left + right
      end
    end
  end
end
