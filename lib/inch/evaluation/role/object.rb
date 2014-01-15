module Inch
  module Evaluation
    module Role
      module Object
        class WithDoc < Base
        end
        class WithoutDoc < BadRole
        end

        class WithCodeExample < Base
        end
        class WithoutCodeExample < BadRole
        end
      end
    end
  end
end
