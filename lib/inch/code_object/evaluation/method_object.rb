module Inch
  module CodeObject
    module Evaluation
      class MethodObject < Base
        DOC_SCORE = 50
        PARAM_SCORE = 40
        RETURN_SCORE = 10

        def evaluate
          if object.has_doc?
            add_score DOC_SCORE
          end

          params = object.parameter_doc
          if params.empty?
            add_score PARAM_SCORE
          else
            per_param = PARAM_SCORE.to_f / params.size
            params.each do |param|
              if param.mentioned?
                add_score per_param * 0.5
              end
              if param.typed?
                add_score per_param * 0.5
              end
            end
          end

          if object.return_typed?
            add_score RETURN_SCORE
          end
        end
      end
    end
  end
end