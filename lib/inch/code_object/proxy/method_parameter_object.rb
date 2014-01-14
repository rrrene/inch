module Inch
  module CodeObject
    module Proxy
      class MethodParameterObject
        attr_reader :name # @return [String] the name of the parameter

        # @param method [Inch::CodeObject::Proxy::MethodObject] the method the parameter belongs_to
        # @param name [String] the name of the parameter
        # @param tag [YARD::Tags::Tag] the Tag object for the parameter
        # @param in_signature [Boolean] +true+ if the method's signature contains the parameter
        def initialize(method, name, tag, in_signature)
          @method = method
          @name = name
          @tag = tag
          @in_signature = in_signature
        end

        # @return [Boolean] +true+ if the parameter is mentioned in the docs
        def mentioned?
          !!@tag || in_method_docstring?
        end

        # @return [Boolean] +true+ if the type of the parameter is defined
        def typed?
          @tag && @tag.types && !@tag.types.empty?
        end

        # @return [Boolean] +true+ if an additional description given?
        def described?
          @tag && !@tag.text.empty?
        end

        # @return [Boolean] +true+ if the parameter is mentioned in the docs, but not present in the method's signature
        def wrongly_mentioned?
          mentioned? && !@in_signature
        end

        private

        def docstring_mention_patterns
          [
            "+#{name}+", 
            "+#{name}+::", 
            "<tt>#{name}</tt>", 
            "<tt>#{name}</tt>::", 
            "#{name}::"
          ]
        end

        def docstring_regexps
          docstring_mention_patterns.map do |pattern|
            r = Regexp.escape(pattern)
            /\W#{r}\W/
          end
        end

        def in_method_docstring?
          docstring_regexps.any? do |pattern|
            @method.docstring.index(pattern)
          end
        end
      end
    end
  end
end
