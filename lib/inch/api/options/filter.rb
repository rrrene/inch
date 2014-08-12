module Inch
  module API
    module Options
      class Filter < Base
        # This module is included here and in Command::Options::BaseList
        # to ensure the same default values for the command-line and library
        # interface
        module DefaultAttributeValues
          DEFAULT_VISIBILITY = [:public, :protected]
        end

        include DefaultAttributeValues

        attribute :visibility, DEFAULT_VISIBILITY
        attribute :namespaces
        attribute :undocumented
        attribute :depth
      end
    end
  end
end
