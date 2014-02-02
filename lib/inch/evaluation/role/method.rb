module Inch
  module Evaluation
    module Role
      module Method
        # Role assigned to methods without parameters
        class WithoutParameters < Base
        end

        # Role assigned to methods with many parameters
        #
        # @see CodeObject::Proxy::MethodObject#has_many_parameters?
        class WithManyParameters < Base
          def priority
            +2
          end
        end


        # Role assigned to methods with many lines
        #
        # @see CodeObject::Proxy::MethodObject#has_many_lines?
        class WithManyLines < Base
          def priority
            +2
          end
        end

        # Role assigned to methods whose name end in a '!'
        class WithBangName < Base
          def priority
            +3
          end
        end

        # Role assigned to methods whose name end in a '?'
        class WithQuestioningName < Base
          def priority
            -4
          end
        end

        # Role assigned to methods which are aliased
        class HasAlias < Base
          def priority
            +2
          end
        end

        # Role assigned to methods that are typed in the docs
        class WithReturnType < Base
        end

        # Role assigned to methods that are not typed in the docs
        class WithoutReturnType < Missing
          def suggestion
            "Describe what '#{object.name}' returns"
          end
        end

        # Role assigned to methods that are overriding another method
        class Overridden < Base
          # It seems more important to document the overridden method,
          # than the overriding one
          def priority
            -2
          end

          # This role doesnot assign a score.
          def score
            nil
          end

          # This role sets a min_score.
          def min_score
            @value.to_f
          end
        end
      end
    end
  end
end
