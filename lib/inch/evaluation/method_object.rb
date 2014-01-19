module Inch
  module Evaluation
    class MethodObject < Base
      DOC_SCORE = 50
      EXAMPLE_SCORE = 10
      PARAM_SCORE = 40
      RETURN_SCORE = 10

      def evaluate
        eval_doc
        eval_parameters
        eval_return_type
        eval_code_example

        if object.overridden?
          add_role Role::Method::Overridden.new(object, object.overridden_method.score)
        end
        if object.has_many_lines?
          add_role Role::Method::WithManyLines.new(object)
        end
        if object.bang_name?
          add_role Role::Method::WithBangName.new(object)
        end
        if object.has_alias?
          add_role Role::Method::HasAlias.new(object)
        end
        if object.nodoc?
          add_role Role::Object::TaggedAsNodoc.new(object)
        end
        if object.in_root?
          add_role Role::Object::InRoot.new(object)
        end
        if object.public?
          add_role Role::Object::Public.new(object)
        end
        if object.protected?
          add_role Role::Object::Protected.new(object)
        end
        if object.private?
          add_role Role::Object::Private.new(object)
        end
      end

      private

      def eval_doc
        if object.has_doc?
          add_role Role::Object::WithDoc.new(object, DOC_SCORE)
        else
          add_role Role::Object::WithoutDoc.new(object, DOC_SCORE)
        end
      end

      def eval_code_example
        if object.has_code_example?
          add_role Role::Object::WithCodeExample.new(object, EXAMPLE_SCORE)
        else
          add_role Role::Object::WithoutCodeExample.new(object, EXAMPLE_SCORE)
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
        if object.return_typed?
          add_role Role::Method::WithReturnType.new(object, RETURN_SCORE)
        else
          add_role Role::Method::WithoutReturnType.new(object, RETURN_SCORE)
        end
      end
    end
  end
end
