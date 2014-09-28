
module Inch
  module Language
    module Nodejs
      module Provider
        module JSDoc
          class Docstring < Ruby::Provider::YARD::Docstring
            # Removes the comment markers // /* */ from the docstring.
            #
            #   Docstring.new("// test").without_comment_markers
            #   # => "test"
            #
            # @return [String]
            def without_comment_markers
              @text.lines.map do |line|
                line.strip.gsub(/^(\s*(\/\*+|\/\/|\*+\/|\*)+\s?)/m, '')
              end.join("\n").strip
            end

            def describes_internal_api?
              tag?(:api, :private) || super
            end

            def describes_parameter?(name)
              return false if name.nil?
              parameter = parameter_notations(name)
              tag?(:param, /#{parameter}\s+\S+/)
            end

            def mentions_parameter?(name)
              return false if name.nil?
              parameter = parameter_notations(name)
              tag?(:param, /#{parameter}/) || super
            end

            def mentions_return?
              tag?(:return) || super
            end

            def describes_return?
              type_notation = /(\{[^\}]+\}|\[[^\]]+\])/
              tag?(:return, /#{type_notation}*(\s\w+)/) || super
            end

            def visibility
              %w(public protected private).detect do |v|
                tag?(v)
              end || 'public'
            end

            def tag?(tagname, regex = nil)
              if without_comment_markers =~ /^\s*\@#{tagname}([^\n]*)$/m
                if regex.nil?
                  true
                else
                  $1 =~ /#{regex}/
                end
              end
            end
          end
        end
      end
    end
  end
end
