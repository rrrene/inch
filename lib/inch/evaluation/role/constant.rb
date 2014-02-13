module Inch
  module Evaluation
    module Role
      # Roles assigned to constants
      module Constant
        class WithDoc < Object::WithDoc
          applicable_if :has_doc?
        end
        class WithoutDoc < Object::WithoutDoc
          applicable_unless :has_doc?
        end

        class TaggedAsNodoc < Object::TaggedAsNodoc
          applicable_if :nodoc?
        end
        class InRoot < Object::InRoot
          applicable_if :root?
        end

        class Public < Object::Public
          applicable_if :public?

          def priority
            -1
          end
        end
        class Private < Object::Private
          applicable_if :private?

          def priority
            -3
          end
        end

        class WithCodeExample < Object::WithCodeExample
          applicable_if do |o|
            o.has_code_example? && !o.has_multiple_code_examples?
          end
        end

        class WithMultipleCodeExamples < Object::WithMultipleCodeExamples
          applicable_if :has_multiple_code_examples?
        end

        class WithoutCodeExample < Object::WithoutCodeExample
          applicable_unless :has_code_example?

          def suggestion
            nil
          end
        end
      end
    end
  end
end
