module Inch
  module CodeObjectProxy
    class ClassObject < Base
      def_delegators :object, :superclass
    end
  end
end
