module Inch
  module Language
    module Elixir
      module Evaluation
        # Proxy class for functions
        class FunctionObject < Base
          def evaluate
            super
            evaluate_parameters
          end

          protected

          def relevant_roles
            relevant_base_roles.merge(relevant_function_roles)
          end

          private

          def evaluate_parameters
            params = object.parameters
            per_param = score_for_single_parameter
            params.each do |param|
              role_classes = relevant_parameter_roles(param, per_param)
              __evaluate(param, role_classes)
            end
          end

          def relevant_function_roles
            {
              Role::Function::Getter => nil,
              Role::Function::Setter => nil,
              Role::Function::Overridden =>
                if object.overridden?
                  object.overridden_method.score
                else
                  nil
                end,
              Role::Function::WithBangName => nil,
              Role::Function::WithQuestioningName => nil
            }
          end

          def relevant_parameter_roles(_param, per_param)
            score_for_mention = per_param
            score_for_type = 0
            {
              Role::FunctionParameter::WithWrongMention =>
                -score_for(:parameters),
              Role::FunctionParameter::WithMention => score_for_mention,
              Role::FunctionParameter::WithoutMention => score_for_mention,
              Role::FunctionParameter::WithType => score_for_type,
              Role::FunctionParameter::WithoutType => score_for_type,
              Role::FunctionParameter::WithBadName => nil,
            }
          end

          def score_for_single_parameter
            @param_score ||= score_for(:parameters) / object.parameters.size
          end

        end
      end
    end
  end
end
