module Inch
  module Evaluation
    class MethodObject < Base
      DOC_SCORE = 50
      EXAMPLE_SCORE = 10
      PARAM_SCORE = 40
      RETURN_SCORE = 10

      def evaluate
        eval_doc
        if object.overridden?
          add_role Role::Method::Overridden.new(self, object.overridden_method.score)
        end
        if object.has_parameters?
          eval_all_parameters
        else
          eval_no_parameters
        end
        eval_return_type
      end

      private

      def set_min_score(default)
        if object.overridden?
          @min_score = object.overridden_method.score
        else
          @min_score = default
        end
      end

      def eval_doc
        if object.has_doc?
          add_role Role::Object::WithDoc.new(object, DOC_SCORE)
        end
        if object.has_code_example?
          add_role Role::Object::WithCodeExample.new(object, EXAMPLE_SCORE)
        end
      end

      def eval_no_parameters
        if score > min_score
          add_role Role::Method::WithoutParameters.new(object, PARAM_SCORE)
        end
      end

      def eval_all_parameters
        params = object.parameters
        per_param = PARAM_SCORE.to_f / params.size
        params.each do |param|
          if param.mentioned?
            if param.wrongly_mentioned?
              add_role Role::MethodParameter::WithWrongMention.new(param, -PARAM_SCORE)
            else
              add_role Role::MethodParameter::WithMention.new(param, per_param * 0.5)
            end
          end
          if param.typed?
            add_role Role::MethodParameter::WithType.new(param, per_param * 0.5)
          end
        end
      end

      def eval_return_type
        if object.return_typed?
          add_role Role::Method::WithReturnType.new(object, RETURN_SCORE)
        end
      end
    end
  end
end