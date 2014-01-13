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
        end

        private

        def eval_doc
          if object.has_doc?
            add_score Score::ObjectHasDoc.new(object, DOC_SCORE)
          end
        end

        def eval_no_parameters
          if score > min_score
            add_score Score::MethodHasNoParameters.new(object, PARAM_SCORE)
          end
        end

        def eval_all_parameters
          params = object.parameters
          per_param = PARAM_SCORE.to_f / params.size
          params.each do |param|
            if param.mentioned?
              add_score Score::MethodParameterIsMentioned.new(param, per_param * 0.5)
            end
            if param.typed?
              add_score Score::MethodParameterIsTyped.new(param, per_param * 0.5)
            end
          end
        end

        def eval_return_type
          if object.return_typed?
            add_score Score::MethodHasReturnType.new(object, RETURN_SCORE)
          end
        end
      end
    end
  end
end