module Inch
  module Language
    module Ruby
      module Provider
        module YARD
          class Docstring
            def initialize(text)
              @text = text.to_s
            end

            def describes_internal_api?
              first_line =~ /^Internal\:\ .+/
            end

            def describes_private_object?
              first_line =~ /^Private\:\ .+/
            end

            def empty?
              @text.strip.empty?
            end

            def contains_code_example?
              !code_examples.empty?
            end

            def code_examples
              @code_examples ||= parse_code_examples
            end

            def describes_parameter?(name)
              return false if name.nil?
              describe_parameter_regexps(name).any? do |pattern|
                @text.index(pattern)
              end
            end

            def mentions_parameter?(name)
              return false if name.nil?
              mention_parameter_regexps(name).any? do |pattern|
                @text.index(pattern)
              end
            end

            def mentions_return?
              last_lines.any? do |line|
                line =~ /^#{tomdoc_modifiers}(Returns|Gets|Sets|Gets\/Sets)\ /
              end
            end

            def describes_return?
              last_lines.any? do |line|
                line =~ /^#{tomdoc_modifiers}(Returns|Gets|Sets|Gets\/Sets)\ (\w+\s){2,}/i ||
                  line =~ /^#{tomdoc_modifiers}(Returns|Gets|Sets|Gets\/Sets)\ (nil|nothing)\.*/i
              end
            end

            def to_s
              @text
            end

            protected

            def first_line
              @first_line ||= @text.lines.to_a.first
            end

            # Returns the last lines of the docstring.
            # @return [Array<String>] the last line and, if the last line(s) is
            #   indented, the last unindented line
            def last_lines
              @last_lines ||= begin
                list = []
                @text.lines.to_a.reverse.each do |line|
                  list << line
                  break if line =~ /^\S/
                end
                list.reverse
              end
            end

            def parse_code_examples
              code_examples = []
              example = nil
              @text.lines.each do |line|
                if line =~ /^\s*+$/
                  code_examples << example if example
                  example = []
                elsif line =~ /^\ {2,}\S+/
                  example << line if example
                else
                  code_examples << example if example
                  example = nil
                end
              end
              code_examples << example if example
              code_examples.delete_if(&:empty?).map(&:join)
            end

            # Returns patterns in which method parameters are mentioned
            # in inline docs.
            #
            # @param name [String] the name of the method parameter
            # @return [Array<Regexp>]
            def mention_parameter_patterns(name)
              expr = parameter_notations(name)
              [
                /#{expr}\:\:/,            # param1::
                /\`#{expr}\`/,            # `param1`
                /\+#{expr}\+/,            # +param1+
                /\+#{expr}\+\:\:/,        # +param1+::
                /<tt>#{expr}<\/tt>/,      # <tt>param1</tt>
                /<tt>#{expr}<\/tt>\:\:/,  # <tt>param1</tt>::
                /^#{expr}\ +\-\ /         # param1 -
              ]
            end

            # Returns possible notations for +name+.
            # matches "param1" and "param1<String,nil>"
            # @return [Regexp]
            def parameter_notations(name)
              escaped_name = Regexp.escape(name)
              type = /<[^>]+>/
              /(#{escaped_name}|#{escaped_name}#{type})/
            end

            # Returns regexes to match parameter description on the next
            # line.
            def describe_parameter_extra_regexps(name)
              [
                "#{name}::",
                "+#{name}+::",
                "<tt>#{name}</tt>::"
              ].map do |pattern|
                r = pattern.is_a?(Regexp) ? pattern : Regexp.escape(pattern)
                /#{r}\n\ {2,}.+/m
              end
            end

            def describe_parameter_regexps(name)
              same_line_regexps =
                mention_parameter_patterns(name).map do |pattern|
                  r = pattern.is_a?(Regexp) ? pattern : Regexp.escape(pattern)
                  /^#{r}\s?\S+/
                end
              same_line_regexps + describe_parameter_extra_regexps(name)
            end

            def mention_parameter_regexps(name)
              mention_parameter_patterns(name).map do |pattern|
                if pattern.is_a?(Regexp)
                  pattern
                else
                  r = Regexp.escape(pattern)
                  /\W#{r}\W/
                end
              end
            end

            def tomdoc_modifiers
              /((Public|Private|Internal)\:\ )*/
            end
          end
        end
      end
    end
  end
end
