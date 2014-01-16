module Inch
  module Evaluation
    module Role
      module MethodParameter
        class WithMention < Base
        end
        class WithoutMention < BadRole
        end

        class WithType < Base
        end
        class WithoutType < BadRole
        end

        class Splat < Base
          def priority
            +1
          end
        end
        class Block < Base
          def priority
            +1
          end
        end

        class WithWrongMention < BadRole
          def priority
            +1
          end
        end
        class WithBadName < Base
          # +priority
          def priority
            +1
          end
        end
      end
    end
  end
end
