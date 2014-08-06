module Inch
  module Evaluation
    module Role
      # Roles assigned to method parameters
      #
      # @note The +object+ is a MethodParameterObject here!
      module MethodParameter
        # Role assigned to parameters that are mentioned in the docs
        #
        # @see CodeObject::Proxy::MethodParameterObject#mentioned?
        class WithMention < Base
          applicable_if :mentioned?
        end

        # Role assigned to parameters that are not mentioned in the docs
        #
        # @see CodeObject::Proxy::MethodParameterObject#mentioned?
        class WithoutMention < Missing
          applicable_unless :mentioned?

          def suggestion
            "Describe the parameter '#{object.name}'"
          end
        end

        # Role assigned to parameters that are typed in the docs
        #
        # @see CodeObject::Proxy::MethodParameterObject#typed?
        class WithType < Base
          applicable_if :typed?
        end

        # Role assigned to parameters that are not typed in the docs
        #
        # @see CodeObject::Proxy::MethodParameterObject#typed?
        class WithoutType < Missing
          applicable_unless :typed?
        end

        # Role assigned to parameters that are spalts, e.g. +*args+
        #
        # @see CodeObject::Proxy::MethodParameterObject#splat?
        class Splat < Base
          applicable_if :splat?

          def priority
            +1
          end
        end

        # Role assigned to parameters that are blocks, e.g. +&block+
        #
        # @see CodeObject::Proxy::MethodParameterObject#block?
        class Block < Base
          applicable_if :block?

          def priority
            +1
          end
        end

        # Role assigned to parameters that are documented, but not part of
        # the method signature
        #
        # @see CodeObject::Proxy::MethodParameterObject#wrongly_mentioned?
        class WithWrongMention < Base
          applicable_if :wrongly_mentioned?

          def suggestion
            "The parameter '#{object.name}' seems not to be part of the " \
              "signature."
          end

          def priority
            +1
          end
        end

        # Role assigned to parameters that have a 'bad' name
        #
        # @see CodeObject::Proxy::MethodParameterObject#bad_name?
        class WithBadName < Base
          applicable_if :bad_name?

          def priority
            +1
          end
        end
      end
    end
  end
end
