module Inch
  module CodeObject
    class Docstring
      def initialize(text)
        @text = text.to_s
      end

      def empty?
        @text.strip.empty?
      end

      def contains_code_example?
        @text.match(/\n\s*\n\ {2,}\w+/m)
      end

      def mentions_parameter?(name)
        mention_regexps(name).any? do |pattern|
          @text.index(pattern)
        end
      end

      private

      def parameter_mention_patterns(name)
        [
          "+#{name}+", 
          "+#{name}+::", 
          "<tt>#{name}</tt>", 
          "<tt>#{name}</tt>::", 
          "#{name}::"
        ]
      end

      def mention_regexps(name)
        parameter_mention_patterns(name).map do |pattern|
          r = Regexp.escape(pattern)
          /\W#{r}\W/
        end
      end
    end
  end
end
