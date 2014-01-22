module Inch
  module Evaluation
    module Role
      module Object
        class WithDoc < Base
        end
        class WithoutDoc < Missing
          def suggestion
            "Add a comment describing the #{object_type}"
          end
        end

        class TaggedAsNodoc < Base
          def priority
            -5
          end
        end
        class InRoot < Base
          def priority
            +3
          end
        end

        class Public < Base
          def priority
            +2
          end
        end
        class Protected < Base
          def priority
            +1
          end
        end
        class Private < Base
          def priority
            -2
          end
        end

        class WithCodeExample < Base
        end
        class WithMultipleCodeExamples < Base
        end
        class WithoutCodeExample < Missing
          def suggestion
            "Add a code example (optional)"
          end
        end
      end
    end
  end
end
