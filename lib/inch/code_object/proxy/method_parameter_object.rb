module Inch
  module CodeObject
    module Proxy
      class MethodParameterObject < Struct.new(:name, :in_signature, :mentioned, :types, :description)
        # is the parameter mentioned in the docs
        def mentioned?
          mentioned
        end

        # is the type of the parameter defined
        def typed?
          types && !types.empty?
        end

        # is an additional description given?
        def described?
          description && !description.empty?
        end

        def wrongly_mentioned?
          mentioned? && !in_signature
        end
      end
    end
  end
end
