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
        class WithManyChildren < Base
          # +priority
          def priority
            +1
          end
        end
        class WithManyAttributes < Base
          # +priority
          def priority
            +1
          end
        end

        class WithoutChildren < Base
        end
        class WithoutMethods < Base
          # --priority
          def priority
            -2
          end
        end
        # A 'pure' namespace has only namespaces as children
        class Pure < Base
          # --priority
          def priority
            -2
          end
        end
        # A 'core' namespace is a class or module that is part of the Ruby
        # core. It might appear in the object tree when monkey-patching
        # functionality.
        # But just because we patch Hash does not mean we need to document
        # the Hash class itself.
        class Core < Base
          # --priority
          def priority
            -7
          end
        end
      end
    end
  end
end
