module Inch
  module Evaluation
    module Proxy
      class ConstantObject < Base
        protected

        def relevant_roles
          {
            Role::Constant::WithDoc => score_for(:docstring),
            Role::Constant::WithoutDoc => score_for(:docstring),
            Role::Constant::TaggedAsNodoc => nil,
            Role::Constant::Public => nil,
            Role::Constant::Private => nil,
          }
        end
      end
    end
  end
end
