module Inch
  module CodeObject
    module Proxy
      # a namespace object can have methods and other namespace objects
      # inside itself (e.g. classes and modules)
      class NamespaceObject < Base
        def children
          object.children.map do |o|
            Proxy.for(o)
          end
        end

        def namespace?
          true
        end
      end
    end
  end
end
