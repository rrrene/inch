module Inch
  module Evaluation
    module Role
      module Object
        class WithDoc < Base
        end
        class WithoutDoc < Missing
        end

        class TaggedAsNodoc < Base
          def priority
            -3
          end
        end

        class WithCodeExample < Base
        end
        class WithoutCodeExample < Missing
        end
      end
    end
  end
end
