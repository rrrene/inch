module Inch
  module Evaluation
    module Role
      # Roles assigned to all objects
      module Object
        # Role assigned to objects that are aliases.
        #
        class Alias < Base
          applicable_if :alias?

          def priority
            # not sure about this yet,
            # but aliases should not show up high in the reports
            -7
          end
        end

        # Role assigned to objects with a describing comment (docstring)
        class WithDoc < Base
          applicable_if :has_doc?
        end

        # Role assigned to objects without a docstring
        class WithoutDoc < Missing
          applicable_unless :has_doc?

          def suggestion
            "Add a comment describing the #{object_type}"
          end
        end

        # Tagged means tagged in an unconsidred way, i.e. YARD tags not
        # considered by Inch. Since these tags are parsed from the docstring
        # the object seems undocumented to Inch.
        class Tagged < Base
          applicable_if :has_unconsidered_tags?

          def priority
            -1
          end
        end

        # Role assigned to objects explicitly or implicitly tagged not to be
        # documented.
        #
        # @see CodeObject::NodocHelper
        class TaggedAsNodoc < Base
          applicable_if :nodoc?

          def priority
            -7
          end
        end

        # Role assigned to objects explicitly or implicitly tagged to be part
        # of an API. If the API is 'private'/'internal' TaggedAsInternalAPI is assigned
        # instead.
        class TaggedAsAPI < Base
          applicable_if :api_tag?
        end

        # Role assigned to objects explicitly or implicitly tagged to be part
        # of a private API.
        class TaggedAsInternalAPI < Base
          applicable_if :tagged_as_internal_api?

          def priority
            -5
          end
        end

        # Role assigned to objects explicitly or implicitly tagged to be
        # private.
        #
        # @see CodeObject::NodocHelper
        class TaggedAsPrivate < Base
          applicable_if :tagged_as_private?

          def priority
            -5
          end
        end

        # Role assigned to objects declared in the top-level namespace
        class InRoot < Base
          applicable_if :in_root?

          def priority
            +3
          end
        end

        # Role assigned to public objects
        class Public < Base
          applicable_if :public?

          def priority
            +2
          end
        end

        # Role assigned to protected objects
        class Protected < Base
          applicable_if :protected?

          def priority
            +1
          end
        end

        # Role assigned to private objects
        class Private < Base
          applicable_if :private?

          def priority
            -2
          end
        end

        # Role assigned to objects with a single code example
        class WithCodeExample < Base
          applicable_if do |o|
            o.has_code_example? && !o.has_multiple_code_examples?
          end
        end

        # Role assigned to objects with multiple code examples
        class WithMultipleCodeExamples < Base
          applicable_if :has_multiple_code_examples?
        end

        # Role assigned to objects without a code example
        class WithoutCodeExample < Missing
          applicable_unless :has_code_example?

          def suggestion
            "Add a code example (optional)"
          end
        end
      end
    end
  end
end
