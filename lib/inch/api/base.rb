module Inch
  module API
    # Base class for all APIs
    #
    # @abstract
    class Base
      attr_reader :codebase

      def initialize(codebase, *args)
        @codebase = codebase
      end
    end
  end
end
