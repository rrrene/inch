module Inch
  module Evaluation
    module Role
      # Roles assigned to namespaces (classes and modules)
      module Namespace
        # Role assigned to namespaces with children
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

        # Role assigned to namespaces with many children
        #
        # @see CodeObject::Proxy::NamespaceObject#has_many_children?
        class WithManyChildren < Base
          # +priority
          def priority
            +1
          end
        end

        # Role assigned to namespaces with many attributes
        #
        # @see CodeObject::Proxy::NamespaceObject#has_many_attributes?
        class WithManyAttributes < Base
          # +priority
          def priority
            +1
          end
        end

        # Role assigned to namespaces without any children
        class WithoutChildren < Base
        end

        # Role assigned to namespaces without any methods
        class WithoutMethods < Base
          def priority
            -2
          end
        end

        # A 'pure' namespace has only namespaces as children
        class Pure < Base
          def priority
            -2
          end
        end

        # A 'core' namespace is a class or module that is part of the Ruby
        # core. It might appear in the object tree when monkey-patching
        # functionality.
        # (the reasoning here is: just because we patch Hash does not mean
        # we need to document the Hash class itself)
        class Core < Base
          def priority
            -7
          end
        end
      end
    end
  end
end
