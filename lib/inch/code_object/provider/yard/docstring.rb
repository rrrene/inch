module Inch
  module CodeObject
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
            last_line =~ /^Returns\ /
          end

          def describes_return?
            last_line =~ /^Returns\ (\w+\s){2,}/i ||
              last_line =~ /^Returns\ (nil|nothing)\.*/i
          end

          def to_s
            @text
          end

          private

          def first_line
            @first_line ||= @text.lines.to_a.first
          end

          def last_line
            @last_line ||= @text.lines.to_a.last
          end

          def parse_code_examples
            code_examples = []
            example = nil
            @text.lines.each_with_index do |line, index|
              if line =~/^\s*+$/
                code_examples << example if example
                example = []
              elsif line =~/^\ {2,}\S+/
                example << line if example
              else
                code_examples << example if example
                example = nil
              end
            end
            code_examples << example if example
            code_examples.delete_if(&:empty?).map(&:join)
          end

          def mention_parameter_patterns(name)
            [
              "+#{name}+",
              "+#{name}+::",
              "<tt>#{name}</tt>",
              "<tt>#{name}</tt>::",
              "#{name}::",
              /^#{Regexp.escape(name)}\ \-\ /
            ]
          end

          def describe_parameter_extra_regexps(name)
            [
              "#{name}::",
              "+#{name}+::",
              "<tt>#{name}</tt>::",
            ].map do |pattern|
              r = pattern.is_a?(Regexp) ? pattern : Regexp.escape(pattern)
              /#{r}\n\ {2,}.+/m
            end
          end

          def describe_parameter_regexps(name)
            same_line_regexps = mention_parameter_patterns(name).map do |pattern|
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
        end
      end
    end
  end
end
