module Inch
  module Evaluation
    module Role
      module Constant
        class WithDoc < Object::WithDoc
        end
        class WithoutDoc < Object::WithoutDoc
        end

        class TaggedAsNodoc < Object::TaggedAsNodoc
        end
        class InRoot < Object::InRoot
        end

        class Public < Object::Public
          def priority
            -1
          end
        end
        class Protected < Object::Protected
          def priority
            -2
          end
        end
        class Private < Object::Private
          def priority
            -3
          end
        end

        class WithCodeExample < Object::WithCodeExample
        end
        class WithMultipleCodeExamples < Object::WithMultipleCodeExamples
        end
        class WithoutCodeExample < Object::WithoutCodeExample
          def suggestion
            nil
          end
        end
      end
    end
  end
end
