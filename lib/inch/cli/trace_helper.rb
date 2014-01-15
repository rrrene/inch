module Inch
  module CLI
    module TraceHelper
      # Writes the given +text+ to stdout
      # @param text [String]
      # @return [void]
      def trace(text = "")
        puts text
      end

      def trace_header(text, color)
        trace header(text, color)
      end

      private

      def edged(color, msg, edge = "┃ ")
        edge.method(color).call + msg
      end

      def header(text, color)
        " ".method("on_#{color}").call + 
          " #{text}".ljust(CLI::COLUMNS-1)
            .black.dark.bold
              .method("on_intense_#{color}").call
      end

    end
  end
end
