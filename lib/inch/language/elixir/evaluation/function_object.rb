module Inch
  module Language
    module Elixir
      module Evaluation
        # Proxy class for functions
        class FunctionObject < Base
          protected

          def relevant_roles
            relevant_base_roles.merge(relevant_function_roles)
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
              Role::Function::WithQuestioningName => nil,
            }
          end
        end
      end
    end
  end
end
