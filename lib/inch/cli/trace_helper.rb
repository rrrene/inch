module Inch
  module CLI
    module TraceHelper
      def debug(msg)
        return unless ENV['DEBUG']
        msg.to_s.lines.each do |line|
          trace edged :dark, line.gsub(/\n$/,'').dark
        end
      end

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
        "#".color(color).method("on_#{color}").call +
          " #{text}".ljust(CLI::COLUMNS-1)
            .black.dark.bold
              .method("on_intense_#{color}").call
      end

    end
  end
end
