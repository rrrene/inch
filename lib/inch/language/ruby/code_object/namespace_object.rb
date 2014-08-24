module Inch
  module Language
    module Ruby
      module CodeObject
        # a namespace object can have methods and other namespace objects
        # inside itself (e.g. classes and modules)
        class NamespaceObject < Base
          # The wording is a bit redundant, but this means the class and
          # instance attributes of the namespace
          def attributes
            self[:attributes]
          end

          MANY_ATTRIBUTES_THRESHOLD = 5
          def has_many_attributes?
            attributes.size > MANY_ATTRIBUTES_THRESHOLD
          end

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
