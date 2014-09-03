module Inch
  module Language
    module Nodejs
      module Evaluation
        # Proxy class for modules
        class ModuleObject < Base
          protected

          def relevant_roles
            relevant_base_roles.merge(relevant_namespace_roles)
          end

          # @see Evaluation::Ruby::Base
          def relevant_namespace_roles
            {
              Role::Module::WithoutChildren => nil,
              Role::Module::WithChildren => nil,
              Role::Module::WithManyChildren => nil,
              Role::Module::WithoutMethods => nil,
              Role::Module::Pure => nil
            }
          end
        end
      end
    end
  end
end
