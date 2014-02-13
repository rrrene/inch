module Inch
  module CodeObject
    module Proxy
      # Proxy class for method parameters
      class MethodParameterObject
        attr_reader :name # @return [String]

        BAD_NAME_EXCEPTIONS = %w(id)
        BAD_NAME_THRESHOLD = 3

        # @return [Boolean] +true+ if the name of the parameter is uncommunicative
        def bad_name?
          return false if BAD_NAME_EXCEPTIONS.include?(name)
          name.size < BAD_NAME_THRESHOLD || name =~ /[0-9]$/
        end

        # @return [Boolean] +true+ if the parameter is a block
        def block?
        end

        # @return [Boolean] +true+ if an additional description given?
        def described?
        end

        # @return [Boolean] +true+ if the parameter is mentioned in the docs
        def mentioned?
        end

        # @return [Boolean] +true+ if the parameter is a splat argument
        def splat?
        end

        # @return [Boolean] +true+ if the type of the parameter is defined
        def typed?
        end

        # @return [Boolean] +true+ if the parameter is mentioned in the docs, but not present in the method's signature
        def wrongly_mentioned?
        end

      end
    end
  end
end
