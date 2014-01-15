module Inch
  module Evaluation
    module Role
      module Namespace
        class WithChildren < Base
          # This role doesnot assign a score.
          def score
            0
          end

          # This role sets a max_score.
          def max_score
            # @value.to_f
          end
        end
        
        class WithoutChildren < Base
        end
      end
    end
  end
end
