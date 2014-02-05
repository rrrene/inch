module Inch
  module Evaluation
    class ConstantObject < Base
      def evaluate
        if object.has_doc?
          add_role Role::Constant::WithDoc.new(object, score_for(:docstring))
        else
          add_role Role::Constant::WithoutDoc.new(object, score_for(:docstring))
        end
        if object.nodoc?
          add_role Role::Constant::TaggedAsNodoc.new(object)
        end
        if object.api_tag?
          if object.private_api_tag?
            add_role Role::Object::TaggedAsPrivateAPI.new(object)
          else
            add_role Role::Object::TaggedAsAPI.new(object)
          end
        end
        if object.has_unconsidered_tags?
          count = object.unconsidered_tags.size
          add_role Role::Object::Tagged.new(object, score_for(:unconsidered_tag) * count)
        end
        if object.in_root?
          add_role Role::Constant::InRoot.new(object)
        end
        if object.public?
          add_role Role::Constant::Public.new(object)
        end
        if object.private?
          add_role Role::Constant::Private.new(object)
        end
      end
    end
  end
end
