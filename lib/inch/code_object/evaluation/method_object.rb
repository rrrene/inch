module Inch
  module CodeObject
    module Evaluation
      class MethodObject < Base
        DOC_SCORE = 50
        PARAM_SCORE = 40
        RETURN_SCORE = 10

        def evaluate
          eval_return_type
          eval_doc
          if object.has_parameters?
            eval_all_parameters
          else
            eval_no_parameters
          end
          if object.overridden?
            add_role Role::Method::Overridden.new(self, object.overridden_method.evaluation.score)
          end
        end

        private

        def set_min_score(default)
          if object.overridden?
            @min_score = object.overridden_method.evaluation.score
          else
            @min_score = default
          end
        end

        def eval_doc
          if object.has_doc?
            add_role Role::ObjectWithDoc.new(object, DOC_SCORE)
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
end