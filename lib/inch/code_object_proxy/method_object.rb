module Inch
  module CodeObjectProxy
    class MethodObject < Base
      def_delegators :object, :parameters

      def has_parameter_doc?
        parameters
      end

      def has_parameters?
        !parameters.empty?
      end

      def parameter_doc
        parameters.map do |(name, default_value)|
          tag = paramter_tag(name)
          types = tag && tag.types
          description = tag && tag.text
          MethodParameterDoc.new(name, types, description)
        end
      end

      def paramter_tag(param_name)
        object.tags.detect do |tag|
          tag.tag_name == "param" && tag.name == param_name
        end
      end

      class MethodParameterDoc
        def initialize(mentioned, types, description)
          @mentioned = mentioned
          @types = types
          @description = description
        end

        # is the parameter mentioned in the docs
        def mentioned?
          @mentioned && !@mentioned.empty?
        end

        # is the type of the parameter defined
        def typed?
          @types && !@types.empty?
        end

        # is an additional description given?
        def described?
          @description && !@description.empty?
        end
      end
    end
  end
end
