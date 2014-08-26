module Inch
  module Language
    module Elixir
      module Evaluation
        module Role
          # Roles assigned to modules
          module Module
            # Role assigned to modules with children
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

            # Role assigned to modules with many children
            #
            # @see CodeObject::Ruby::NamespaceObject#has_many_children?
            class WithManyChildren < Base
              applicable_if :has_many_children?

              # +priority
              def priority
                +1
              end
            end

            # Role assigned to modules without any children
            class WithoutChildren < Base
              applicable_unless :has_children?
            end

            # Role assigned to modules without any methods
            class WithoutMethods < Base
              applicable_unless :has_methods?

              def priority
                -2
              end
            end

            # A 'pure' namespace has only modules as children
            class Pure < Base
              applicable_if :pure_namespace?

              def priority
                -2
              end
            end
          end
        end
      end
    end
  end
end
