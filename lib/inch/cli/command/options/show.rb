module Inch
  module CLI
    module Command
      module Options
        class Show < BaseObject
          def verify
            if object_names.empty?
              kill # "Provide a name to an object to show it's evaluation."
            end
          end
        end
      end
    end
  end
end
