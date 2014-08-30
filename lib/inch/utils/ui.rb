# encoding: utf-8

module Inch
  module Utils
    class UI
      attr_reader :out, :err

      def initialize(stdout = $stdout, stderr = $stderr)
        @out, @err = stdout, stderr
      end

      def debug(msg)
        return unless ENV['DEBUG']
        msg.to_s.lines.each do |line|
          trace edged :dark, line.gsub(/\n$/, '').dark
        end
      end

      def sub(msg = '')
        color = @current_header_color || :white
        trace __edged(color, msg)
      end

      def edged(color, msg, edge = '┃ ')
        trace __edged(color, msg, edge)
      end

      # Writes the given +text+ to out
      #
      # @param text [String]
      # @return [void]
      def trace(text = '')
        @current_header_color = nil if text.to_s.empty?
        out.puts text
      end

      # Writes the given +text+ to err
      #
      # @param text [String]
      # @return [void]
      def warn(text = '')
        err.puts text
      end

      def header(text, color, bg_color = nil)
        @current_header_color = color
        trace __header(text, color, bg_color)
        trace unless use_color?
      end

      # @return [Boolean] true if the UI uses coloring
      def use_color?
        Term::ANSIColor.coloring?
      end

      private

      def __edged(color, msg, edge = '┃ ')
        edge.color(color) + msg
      end

      def __header(text, color, bg_color = nil)
        bg_color ||= "intense_#{color}"
        bar = " #{text}".ljust(CLI::COLUMNS - 1)
                .on_color(bg_color).color(:color16)
        '#'.color(color).on_color(color) + bar
      end
    end
  end
end
