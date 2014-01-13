module Inch
  module CLI
    module TraceHelper
      # Writes the given +msg+ to stdout
      # @param msg [String]
      # @return [void]
      def trace(msg = "")
        puts msg
      end
    end
  end
end
