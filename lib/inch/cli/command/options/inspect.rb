module Inch
  module CLI
    module Command
      module Options
        class Inspect < BaseObject
          def descriptions
            [
              '',
              'Example: ' +
                '$ inch inspect lib/**/*.rb Foo::Bar#initialize'.color(:cyan),
              '',
              'Shows one or more objects in detail.'
            ]
          end

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
