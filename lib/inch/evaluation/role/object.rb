module Inch
  module Evaluation
    module Role
      # Roles assigned to all objects
      module Object
        # Role assigned to objects with a describing comment (docstring)
        class WithDoc < Base
        end

        # Role assigned to objects without a docstring
        class WithoutDoc < Missing
          def suggestion
            "Add a comment describing the #{object_type}"
          end
        end

        # Tagged means tagged in an unconsidred way, i.e. YARD tags not
        # considered by Inch. Since these tags are parsed from the docstring
        # the object seems undocumented to Inch.
        class Tagged < Base
          def priority
            -1
          end
        end

        # Role assigned to objects explicitly or implicitly tagged not to be
        # documented.
        #
        # @see CodeObject::NodocHelper
        class TaggedAsNodoc < Base
          def priority
            -7
          end
        end

        # Role assigned to objects explicitly or implicitly tagged to be part
        # of an API. If the API is 'private' TaggedAsPrivateAPI is assigned
        # instead.
        class TaggedAsAPI < Base
        end

        # Role assigned to objects explicitly or implicitly tagged to be part
        # of a private API.
        class TaggedAsPrivateAPI < Base
          def priority
            -5
          end
        end

        # Role assigned to objects declared in the top-level namespace
        class InRoot < Base
          def priority
            +3
          end
        end

        # Role assigned to public objects
        class Public < Base
          def priority
            +2
          end
        end

        # Role assigned to protected objects
        class Protected < Base
          def priority
            +1
          end
        end

        # Role assigned to private objects
        class Private < Base
          def priority
            -2
          end
        end

        # Role assigned to objects with a single code example
        class WithCodeExample < Base
        end

        # Role assigned to objects with multiple code examples
        class WithMultipleCodeExamples < Base
        end

        # Role assigned to objects without a code example
        class WithoutCodeExample < Missing
          def suggestion
            "Add a code example (optional)"
          end
        end
      end
    end
  end
end
