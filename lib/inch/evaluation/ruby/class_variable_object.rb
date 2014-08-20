module Inch
  module Evaluation
    module Ruby
      class ClassVariableObject < Base
        protected

        def relevant_roles
          {
            Role::ClassVariable::WithDoc => score_for(:docstring),
            Role::ClassVariable::WithoutDoc => score_for(:docstring),
            Role::ClassVariable::TaggedAsNodoc => nil,
            Role::ClassVariable::Public => nil,
            Role::ClassVariable::Private => nil
          }
        end
      end
    end
  end
end
