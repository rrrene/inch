module Inch
  module Language
    module Ruby
      module Provider
        module YARD
          module Object
            # Proxy class for method parameters
            class MethodParameterObject
              attr_reader :name # @return [String]

              # @param method [YARD::Object::MethodObject] the method the
              #   parameter belongs to
              # @param name [String] the name of the parameter
              # @param in_signature [String] how the parameter is noted in the
              #   method's signature
              # @param tag [YARD::Tags::Tag] the Tag object for the parameter
              def initialize(method, name, in_signature, tag)
                @method = method
                @name = name
                @tag = tag
                @in_signature = in_signature
              end

              BAD_NAME_EXCEPTIONS = %w(id)
              BAD_NAME_THRESHOLD = 3

              # @return [Boolean] +true+ if the name of the parameter is
              #   uncommunicative
              def bad_name?
                return false if BAD_NAME_EXCEPTIONS.include?(name)
                name.size < BAD_NAME_THRESHOLD || name =~ /[0-9]$/
              end

              # @return [Boolean] +true+ if the parameter is a block
              def block?
                @in_signature.to_s =~ /^\&/
              end

              # @return [Boolean] +true+ if an additional description given?
              def described?
                described_by_tag? || described_by_docstring?
              end

              # @return [Boolean] +true+ if the parameter is mentioned in the
              #   docs
              def mentioned?
                !!@tag || mentioned_by_docstring?
              end

              # @return [Boolean] +true+ if the parameter is a splat argument
              def splat?
                @in_signature.to_s =~ /^\*/
              end

              # @return [Boolean] +true+ if the type of the parameter is defined
              def typed?
                @tag && @tag.types && !@tag.types.empty?
              end

              # @return [Boolean] +true+ if the parameter is mentioned in the
              #   docs, but not present in the method's signature
              def wrongly_mentioned?
                mentioned? && !@in_signature
              end

              private

              def described_by_tag?
                @tag && @tag.text && !@tag.text.empty?
              end

              def described_by_docstring?
                if @method.docstring.describes_parameter?(name)
                  true
                else
                  unsplatted = name.gsub(/^[\&\*]/, '')
                  @method.docstring.describes_parameter?(unsplatted)
                end
              end

              def mentioned_by_docstring?
                if @method.docstring.mentions_parameter?(name)
                  true
                else
                  unsplatted = name.gsub(/^[\&\*]/, '')
                  @method.docstring.mentions_parameter?(unsplatted)
                end
              end
            end
          end
        end
      end
    end
  end
end
