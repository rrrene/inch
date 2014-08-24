module Inch
  module Language
    module Ruby
      module Evaluation
        # a namespace object can have methods and other namespace objects
        # inside itself (e.g. classes and modules)
        class NamespaceObject < Base
          protected

          def relevant_roles
            relevant_base_roles.merge(relevant_namespace_roles)
          end

          # @see Evaluation::Ruby::Base
          def relevant_namespace_roles
            {
              Role::Namespace::Core => nil,
              Role::Namespace::WithManyAttributes => nil,
              Role::Namespace::WithoutChildren => nil,
              Role::Namespace::WithChildren => nil,
              Role::Namespace::WithManyChildren => nil,
              Role::Namespace::WithoutMethods => nil,
              Role::Namespace::Pure => nil
            }
          end
        end
      end
    end
  end
end
