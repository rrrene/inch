module Inch
  module API
    class List < Filter
      def initialize(codebase, options)
        super
        @options = options
      end
    end
  end
end
