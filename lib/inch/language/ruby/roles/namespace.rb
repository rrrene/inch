module Inch
  module Language
    module Ruby
      module Evaluation
        module Role
          # Roles assigned to namespaces (classes and modules)
          module Namespace
            # Role assigned to namespaces with children
            #
            # @see CodeObject::Ruby::NamespaceObject#has_children?
            class WithChildren < Base
              applicable_if :has_children?

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
            # @see CodeObject::Ruby::NamespaceObject#has_many_children?
            class WithManyChildren < Base
              applicable_if :has_many_children?

              # +priority
              def priority
                +1
              end
            end

            # Role assigned to namespaces with many attributes
            #
            # @see CodeObject::Ruby::NamespaceObject#has_many_attributes?
            class WithManyAttributes < Base
              applicable_if :has_many_attributes?

              # +priority
              def priority
                +1
              end
            end

            # Role assigned to namespaces without any children
            class WithoutChildren < Base
              applicable_unless :has_children?
            end

            # Role assigned to namespaces without any methods
            class WithoutMethods < Base
              applicable_unless :has_methods?

              def priority
                -2
              end
            end

            # A 'pure' namespace has only namespaces as children
            class Pure < Base
              applicable_if :pure_namespace?

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
              applicable_if :core?

              def priority
                -7
              end
            end
          end
        end
      end
    end
  end
end
