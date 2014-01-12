module Inch
  module CodeObject
    module Proxy
      class ClassObject < Base
        def_delegators :object, :superclass
      end
    end
  end
end
