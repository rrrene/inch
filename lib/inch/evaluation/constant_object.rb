module Inch
  module Evaluation
    class ConstantObject < Base
      DOC_SCORE = MAX_SCORE

      def evaluate
        if object.has_doc?
          add_role Role::Object::WithDoc.new(object, DOC_SCORE)
        else
          add_role Role::Object::WithoutDoc.new(object, DOC_SCORE)
        end
      end
    end
  end
end
