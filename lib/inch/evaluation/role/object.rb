module Inch
  module Evaluation
    module Role
      module Object
        class WithDoc < Base
        end
        class WithoutDoc < BadRole
        end

        class TaggedAsNodoc < Base
          def priority
            -3
          end
        end

        class WithCodeExample < Base
        end
        class WithoutCodeExample < BadRole
        end
      end
    end
  end
end
