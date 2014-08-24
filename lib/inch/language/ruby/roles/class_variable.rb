module Inch
  module Language
    module Ruby
      module Evaluation
        module Role
          # Roles assigned to class variables
          module ClassVariable
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
              applicable_if :in_root?
            end

            class Public < Object::Public
              applicable_if :public?
              priority      -1
            end
            class Private < Object::Private
              applicable_if :private?
              priority      -3
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
  end
end
