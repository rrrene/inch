module Inch
  module CLI
    module Command
      module Options
        class Show < BaseObject
          def descriptions
            [
              '',
              'Example: ' +
                '$ inch show lib/**/*.rb Foo::Bar#initialize'.color(:cyan),
              '',
              'Shows one or more objects in detail.',
              description_hint_grades,
              description_hint_arrows
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
