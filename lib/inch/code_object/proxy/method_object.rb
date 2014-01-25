module Inch
  module CodeObject
    module Proxy
      class MethodObject < Base
        def comment_and_abbrev_source
          comments.join('') + abbrev_source
        end

        def bang_name?
          name =~ /\!$/
        end

        def has_parameters?
          !parameters.empty?
        end

        MANY_PARAMETERS_THRESHOLD = 3
        def has_many_parameters?
          parameters.size > MANY_PARAMETERS_THRESHOLD
        end

        MANY_LINES_THRESHOLD = 20
        def has_many_lines?
          # for now, this includes the 'def' line and comments
          if source = object.source
            size = source.lines.count
            size > MANY_LINES_THRESHOLD
          else
            false
          end
        end

        def method?
          true
        end

        def parameters
          @parameters ||= all_parameter_names.map do |name|
            in_signature = signature_parameter_names.include?(name)
            tag = parameter_tag(name)
            MethodParameterObject.new(self, name, tag, in_signature)
          end
        end

        def parameter(name)
          parameters.detect { |p| p.name == name.to_s }
        end

        def overridden?
          !!object.overridden_method
        end

        def overridden_method
          @overridden_method ||= Proxy.for(object.overridden_method)
        end

        def return_mentioned?
          !!return_tag || docstring.mentions_return?
        end

        private

        def all_parameter_names
          names = signature_parameter_names
          names.concat parameter_tags.map(&:name)
          names.compact.uniq
        end

        def abbrev_source
          lines = object.source.to_s.lines
          if lines.size >= 5
            indent = lines[1].scan(/^(\s+)/).flatten.join('')
            lines = lines[0..1] +
                    ["#{indent}# ... snip ...\n"] +
                    lines[-2..-1]
          end
          lines.join('')
        end

        def comments
          @comments ||= files.map do |(filename, line_no)|
            get_lines_up_while(filename, line_no - 1) do |line|
              line =~ /^\s*#/
            end.flatten.join('')
          end
        end

        def get_lines_up_while(filename, line_no, &block)
          lines = []
          line = get_line_no(filename, line_no)
          if yield(line) && line_no > 0
            lines << line.gsub(/^(\s+)/, '')
            lines << get_lines_up_while(filename, line_no - 1, &block)
          end
          lines.reverse
        end

        def signature_parameter_names
          object.parameters.map(&:first)
        end

        def parameter_tag(param_name)
          parameter_tags.detect do |tag|
            tag.name == param_name
          end
        end

        def parameter_tags
          object.tags(:param)
        end

        def return_tag
          object.tags(:return).first
        end
      end
    end
  end
end
