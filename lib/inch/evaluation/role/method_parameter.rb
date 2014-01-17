module Inch
  module Evaluation
    module Role
      module MethodParameter
        class WithMention < Base
        end
        class WithoutMention < Missing
        end

        class WithType < Base
        end
        class WithoutType < Missing
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

        class WithWrongMention < Missing
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
