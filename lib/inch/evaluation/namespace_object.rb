module Inch
  module Evaluation
    # a namespace object can have methods and other namespace objects
    # inside itself (e.g. classes and modules)
    class NamespaceObject < Base
      DOC_SCORE = MAX_SCORE
      EXAMPLE_SCORE = 10

      def evaluate
        if object.has_doc?
          add_role Role::Object::WithDoc.new(object, DOC_SCORE)
        else
          add_role Role::Object::WithoutDoc.new(object, DOC_SCORE)
        end
        if object.has_code_example?
          add_role Role::Object::WithCodeExample.new(object, EXAMPLE_SCORE)
        else
          add_role Role::Object::WithoutCodeExample.new(object, EXAMPLE_SCORE)
        end
        if children.empty?
          add_role Role::Namespace::WithoutChildren.new(self)
        else
          add_role Role::Namespace::WithChildren.new(self, children.map(&:score).min)
        end
      end

      private

      def children
        @children ||= object.children.map(&:evaluation)
      end
    end
  end
end
