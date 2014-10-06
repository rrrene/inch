module Inch
  module Language
    module Elixir
      module CodeObject
        # Proxy class for method parameters
        class FunctionParameterObject
          def initialize(attributes)
            @attributes = attributes
          end

          def [](key)
            @attributes[key]
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
            self[:block?]
          end

          # @return [Boolean] +true+ if an additional description given?
          def described?
            self[:described?]
          end

          # @return [Boolean] +true+ if the parameter is mentioned in the docs
          def mentioned?
            self[:mentioned?]
          end

          def name
            self[:name]
          end
          alias_method :fullname, :name

          # @return [Boolean] +true+ if the parameter is a splat argument
          def splat?
            self[:splat?]
          end

          # @return [Boolean] +true+ if the type of the parameter is defined
          def typed?
            self[:typed?]
          end

          def unnamed?
            name == ''
          end

          # @return [Boolean] +true+ if the parameter is mentioned in the docs,
          #   but not present in the method's signature
          def wrongly_mentioned?
            self[:wrongly_mentioned?]
          end
        end
      end
    end
  end
end
