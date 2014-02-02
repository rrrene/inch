module Inch
  module Evaluation
    module Role
      # Roles assigned to method parameters
      module MethodParameter
        # Role assigned to parameters that are mentioned in the docs
        class WithMention < Base
        end

        # Role assigned to parameters that are not mentioned in the docs
        class WithoutMention < Missing
          def suggestion
            "Describe the parameter '#{object.name}'"
          end
        end

        # Role assigned to parameters that are typed in the docs
        class WithType < Base
        end

        # Role assigned to parameters that are not typed in the docs
        class WithoutType < Missing
        end

        # Role assigned to parameters that are spalts, e.g. +*args+
        class Splat < Base
          def priority
            +1
          end
        end

        # Role assigned to parameters that are blocks, e.g. +&block+
        class Block < Base
          def priority
            +1
          end
        end

        # Role assigned to parameters that are documented, but not part of
        # the method signature
        class WithWrongMention < Missing
          def suggestion
            "The parameter '#{object.name}' seems not to be part of the signature."
          end
          def priority
            +1
          end
        end

        # Role assigned to parameters that have a 'bad' name
        #
        # @see CodeObject::Proxy::MethodParameterObject#bad_name?
        class WithBadName < Base
          def priority
            +1
          end
        end
      end
    end
  end
end
