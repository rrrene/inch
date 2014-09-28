module Inch
  module Language
    module Elixir
      module Provider
        module Reader
          module Object
            # Proxy class for function parameters
            class FunctionParameterObject
              attr_reader :name # @return [String]

              # @param method [YARD::Object::MethodObject] the method the
              #   parameter belongs to
              # @param name [String] the name of the parameter
              def initialize(method, name)
                @method = method
                @name = name
              end

              # @return [Boolean] +true+ if the parameter is a block
              def block?
                false
              end

              # @return [Boolean] +true+ if an additional description is given?
              def described?
                described_by_docstring?
              end

              # @return [Boolean] +true+ if the parameter is mentioned in the
              #   docs
              def mentioned?
                mentioned_by_docstring?
              end

              # @return [Boolean] +true+ if the parameter is a splat argument
              def splat?
                false
              end

              # @return [Boolean] +true+ if the type of the parameter is defined
              def typed?
                false # TODO: parse types of params
              end

              # @return [Boolean] +true+ if the parameter is mentioned in the
              #   docs, but not present in the method's signature
              def wrongly_mentioned?
                false
              end

              private

              def described_by_docstring?
                @method.docstring.describes_parameter?(name)
              end

              def mentioned_by_docstring?
                @method.docstring.mentions_parameter?(name)
              end
            end
          end
        end
      end
    end
  end
end
