module Inch
  module CodeObject
    module Proxy
      class MethodObject < Base
        def_delegators :object, :parameters

        def has_parameters?
          !parameters.empty?
        end

        def method?
          true
        end

        def parameter_doc
          parameters.map do |(name, default_value)|
            tag = paramter_tag(name)
            mentioned = !!tag
            types = tag && tag.types
            description = tag && tag.text
            MethodParameterDoc.new(name, mentioned, types, description)
          end
        end

        def return_typed?
          !!return_tag
        end

        private

        def paramter_tag(param_name)
          object.tags(:param).detect do |tag|
            tag.name == param_name
          end
        end

        def return_tag
          object.tags(:return).first
        end

        class MethodParameterDoc < Struct.new(:name, :mentioned, :types, :description)
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
        end
      end
    end
  end
end