module Inch
  module Evaluation
    class ConstantObject < Base
      DOC_SCORE = MAX_SCORE

      def evaluate
        if object.has_doc?
          add_role Role::Constant::WithDoc.new(object, DOC_SCORE)
        else
          add_role Role::Constant::WithoutDoc.new(object, DOC_SCORE)
        end
        if object.nodoc?
          add_role Role::Constant::TaggedAsNodoc.new(object)
        end
        if object.has_unconsidered_tags?
          count = object.unconsidered_tags.size
          add_role Role::Object::Tagged.new(object, TAGGED_SCORE * count)
        end
        if object.in_root?
          add_role Role::Constant::InRoot.new(object)
        end
        if object.public?
          add_role Role::Constant::Public.new(object)
        end
        if object.protected?
          add_role Role::Constant::Protected.new(object)
        end
        if object.private?
          add_role Role::Constant::Private.new(object)
        end
      end
    end
  end
end
