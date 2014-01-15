module Inch
  module Evaluation
    module Role
      class BadRole < Base
        def score
          nil
        end

        def potential_score
          @value.to_f
        end
      end
    end
  end
end
