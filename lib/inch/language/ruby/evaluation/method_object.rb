module Inch
  module Language
    module Ruby
      module Evaluation
        class MethodObject < Base
          def evaluate
            super
            evaluate_parameters
          end

          protected

          def relevant_roles
            relevant_base_roles.merge(relevant_method_roles)
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

          def relevant_method_roles
            {
              Role::Method::Constructor => nil,
              Role::Method::Getter => nil,
              Role::Method::Setter => nil,
              Role::Method::Overridden =>
                if object.overridden?
                  object.overridden_method.score
                else
                  nil
                end,
              Role::Method::WithManyLines => nil,
              Role::Method::WithBangName => nil,
              Role::Method::WithQuestioningName => nil,
              Role::Method::HasAlias => nil,
              Role::Method::WithReturnType => score_for(:return_type),
              Role::Method::WithoutReturnType => score_for(:return_type),
              Role::Method::WithReturnDescription =>
                score_for(:return_description),
              Role::Method::WithoutReturnDescription =>
                score_for(:return_description),
              Role::Method::WithoutParameters => score_for(:parameters),
              Role::Method::WithManyParameters => nil
            }
          end

          def relevant_parameter_roles(_param, per_param)
            {
              Role::MethodParameter::WithWrongMention =>
                -score_for(:parameters),
              Role::MethodParameter::WithMention => per_param * 0.5,
              Role::MethodParameter::WithoutMention => per_param * 0.5,
              Role::MethodParameter::WithType => per_param * 0.5,
              Role::MethodParameter::WithoutType => per_param * 0.5,
              Role::MethodParameter::WithBadName => nil,
              Role::MethodParameter::Block => nil,
              Role::MethodParameter::Splat => nil
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
