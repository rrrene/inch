module Inch
  module CodeObject
    module Proxy
      class ClassObject < NamespaceObject
        def_delegators :object, :superclass
      end
    end
  end
end
