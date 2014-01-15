module Inch
  module Evaluation
    module Role
      module MethodParameter
        class WithMention < Base
        end
        class WithoutMention < BadRole
        end

        class WithWrongMention < BadRole
        end

        class WithType < Base
        end
        class WithoutType < BadRole
        end
      end
    end
  end
end
