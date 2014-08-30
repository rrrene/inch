require 'inch/utils/ui'

module Inch
  module CLI
    # Adds a method called +ui+, that can be used to output messages to the
    # user.
    module TraceHelper
      def ui
        @ui ||= Inch::Utils::UI.new
      end
    end
  end
end
