module Inch
  module Language
    module Ruby
      module Provider
        module YARD
          module Object
            # a namespace object can have methods and other namespace objects
            # inside itself (e.g. classes and modules)
            class NamespaceObject < Base
              def attributes
                object.class_attributes.values +
                  object.instance_attributes.values
              end

              def children_fullnames
                children.map(&:fullname)
              end

              def namespace?
                true
              end

              def has_methods?
                children.any?(&:method?)
              end

              def pure_namespace?
                children.all?(&:namespace?)
              end

              # called by MethodObject#getter?
              def child(name)
                children.find { |child| child.name == name } if children
              end

              def children
                object.children.map do |o|
                  YARD::Object.for(o)
                end
              end
            end
          end
        end
      end
    end
  end
end
