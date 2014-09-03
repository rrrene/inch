module Inch
  module Language
    module Nodejs
      module Evaluation
        # Base class for all Nodejs related evaluations
        #
        # @abstract
        class Base < Inch::Evaluation::Proxy
          protected

          def relevant_base_roles
            {
              Role::Object::InRoot => nil,
              Role::Object::Public => nil,
              Role::Object::TaggedAsNodoc => nil,
              Role::Object::WithDoc => score_for(:docstring),
              Role::Object::WithoutDoc => score_for(:docstring),
              Role::Object::WithCodeExample => score_for(:code_example_single),
              Role::Object::WithMultipleCodeExamples =>
                score_for(:code_example_multi),
              Role::Object::WithoutCodeExample =>
                score_for(:code_example_single)
            }
          end
        end
      end
    end
  end
end
