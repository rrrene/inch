module Inch
  module Evaluation
    class MethodObject < Base
      def evaluate
        eval_doc
        eval_code_example
        eval_visibility
        eval_tags
        
        eval_parameters
        eval_return_type
        eval_method
      end

      private

      def eval_method
        if object.constructor?
          add_role Role::Method::Constructor.new(object)
        end
        if object.getter?
          add_role Role::Method::Getter.new(object)
        end
        if object.setter?
          add_role Role::Method::Setter.new(object)
        end
        if object.overridden?
          add_role Role::Method::Overridden.new(object, object.overridden_method.score)
        end
        if object.has_many_lines?
          add_role Role::Method::WithManyLines.new(object)
        end
        if object.bang_name?
          add_role Role::Method::WithBangName.new(object)
        end
        if object.questioning_name?
          add_role Role::Method::WithQuestioningName.new(object)
        end
        if object.has_alias?
          add_role Role::Method::HasAlias.new(object)
        end
      end

      def eval_parameters
        if object.has_parameters?
          eval_all_parameters
        else
          eval_no_parameters
        end
      end

      def eval_no_parameters
        if score > min_score
          add_role Role::Method::WithoutParameters.new(object, score_for(:parameters))
        end
      end

      def eval_all_parameters
        params = object.parameters
        per_param = score_for(:parameters) / params.size
        params.each do |param|
          if param.mentioned?
            if param.wrongly_mentioned?
              add_role Role::MethodParameter::WithWrongMention.new(param, -score_for(:parameters))
            else
              add_role Role::MethodParameter::WithMention.new(param, per_param * 0.5)
            end
          else
            add_role Role::MethodParameter::WithoutMention.new(param, per_param * 0.5)
          end
          if param.typed?
            add_role Role::MethodParameter::WithType.new(param, per_param * 0.5)
          else
            add_role Role::MethodParameter::WithoutType.new(param, per_param * 0.5)
          end
          if param.bad_name?
            add_role Role::MethodParameter::WithBadName.new(param)
          end
          if param.block?
            add_role Role::MethodParameter::Block.new(param)
          end
          if param.splat?
            add_role Role::MethodParameter::Splat.new(param)
          end
        end
        if object.has_many_parameters?
          add_role Role::Method::WithManyParameters.new(object)
        end
      end

      def eval_return_type
        if object.return_mentioned?
          add_role Role::Method::WithReturnType.new(object, score_for(:return_type))
        else
          add_role Role::Method::WithoutReturnType.new(object, score_for(:return_type))
        end
        if object.return_described?
          add_role Role::Method::WithReturnDescription.new(object, score_for(:return_description))
        else
          add_role Role::Method::WithoutReturnDescription.new(object, score_for(:return_description))
        end
      end
    end
  end
end
