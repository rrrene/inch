module Inch
  module Evaluation
    module Role
      module Method
        class WithoutParameters < Base
        end
        class WithManyParameters < Base
          # +priority
          def priority
            +2
          end
        end
        class WithManyLines < Base
          # +priority
          def priority
            +2
          end
        end
        class WithBangName < Base
          # +priority
          def priority
            +3
          end
        end
        class HasAlias < Base
          # +priority
          def priority
            +2
          end
        end

        class WithReturnType < Base
        end
        class WithoutReturnType < Missing
          def suggestion
            "Describe the return type of '#{object.name}'"
          end
        end

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
