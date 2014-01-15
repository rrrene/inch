module Inch
  module Evaluation
    module Role
      module Method
        class WithoutParameters < Base
        end

        class WithReturnType < Base
        end

        class Overridden < Base
          # This role doesnot assign a score.
          def score
            0
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
