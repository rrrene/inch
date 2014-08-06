module Inch
  module Evaluation
    module Role
      module Method
        # Role assigned to methods without parameters
        class WithoutParameters < Base
          applicable_unless :has_parameters?
        end

        # Role assigned to methods with many parameters
        #
        # @see CodeObject::Proxy::MethodObject#has_many_parameters?
        class WithManyParameters < Base
          applicable_if :has_many_parameters?

          def priority
            +2
          end
        end

        # Role assigned to methods where the return value is typed in the docs
        class WithReturnType < Base
          applicable_if :return_typed?
        end

        # Role assigned to methods where the return value is not typed
        class WithoutReturnType < Missing
          applicable_unless :return_typed?

          def suggestion
            "Describe what '#{object.name}' returns"
          end
        end

        # Role assigned to methods where the return value is decribed in the docs
        class WithReturnDescription < Base
          applicable_if :return_described?
        end

        # Role assigned to methods where the return value is not decribed
        class WithoutReturnDescription < Missing
          applicable_unless :return_described?

          def suggestion
            "Describe what '#{object.name}' returns"
          end
        end

        # Role assigned to methods with many lines
        #
        # @see CodeObject::Proxy::MethodObject#has_many_lines?
        class WithManyLines < Base
          applicable_if :has_many_lines?

          def priority
            +2
          end
        end

        # Role assigned to methods whose name end in a '!'
        class WithBangName < Base
          applicable_if :bang_name?

          def priority
            +3
          end
        end

        # Role assigned to methods whose name end in a '?'
        class WithQuestioningName < Base
          applicable_if :questioning_name?

          def priority
            -4
          end
        end

        # Role assigned to methods which are aliased
        class HasAlias < Base
          applicable_if :has_alias?

          def priority
            +2
          end
        end

        # Role assigned to methods that are constructors
        class Constructor < Base
          applicable_if :constructor?
        end

        # Role assigned to methods that are getters
        class Getter < Base
          applicable_if :getter?
        end

        # Role assigned to methods that are setters
        class Setter < Base
          applicable_if :setter?
        end

        # Role assigned to methods that are overriding another method
        class Overridden < Base
          applicable_if :overridden?

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
