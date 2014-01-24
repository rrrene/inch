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
        trace if !use_color?
      end

      private

      def edged(color, msg, edge = "┃ ")
        edge.color(color) + msg
      end

      def header(text, color)
        h = "#".color(color).method("on_#{color}").call +
              " #{text}".ljust(CLI::COLUMNS-1)
                .black.bold
                .method("on_intense_#{color}").call
        CLI.mac? ? h : h.dark
      end

      def use_color?
        Term::ANSIColor::coloring?
      end

    end
  end
end
