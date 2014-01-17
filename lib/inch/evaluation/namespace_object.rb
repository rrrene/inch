module Inch
  module Evaluation
    # a namespace object can have methods and other namespace objects
    # inside itself (e.g. classes and modules)
    class NamespaceObject < Base
      DOC_SCORE = MAX_SCORE
      EXAMPLE_SCORE = 10

      def evaluate
        eval_doc
        eval_children

        if object.has_many_attributes?
          add_role Role::Namespace::WithManyAttributes.new(object)
        end
        if object.nodoc?
          add_role Role::Object::TaggedAsNodoc.new(object)
        end
        if object.in_root?
          add_role Role::Object::InRoot.new(object)
        end
      end

      private

      def eval_doc
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
      end

      def eval_children
        if children.empty?
          add_role Role::Namespace::WithoutChildren.new(object)
        else
          add_role Role::Namespace::WithChildren.new(object, children.map(&:score).min)
          if object.pure_namespace?
            add_role Role::Namespace::Pure.new(object)
          end
          if object.no_methods?
            add_role Role::Namespace::WithoutMethods.new(object)
          end
          if object.has_many_children?
            add_role Role::Namespace::WithManyChildren.new(object)
          end
        end
      end

      def children
        @children ||= object.children.map(&:evaluation)
      end
    end
  end
end
