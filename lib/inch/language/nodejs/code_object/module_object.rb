module Inch
  module Language
    module Nodejs
      module CodeObject
        # Proxy class for modules
        class ModuleObject < Base
          MANY_CHILDREN_THRESHOLD = 20
          def has_many_children?
            children.size > MANY_CHILDREN_THRESHOLD
          end

          def has_methods?
            children.any?(&:method?)
          end

          def pure_namespace?
            children.all?(&:namespace?)
          end
        end
      end
    end
  end
end
