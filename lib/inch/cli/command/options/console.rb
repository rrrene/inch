module Inch
  module CLI
    module Command
      module Options
        class Console < BaseObject
          def descriptions
            [
              '',
              'Provides a PRY based REPL to inspect objects.',
              '',
              'Example: ' +
                '$ inch console lib/**/*.rb Foo::Bar#initialize'.color(:cyan),
              '',
              'Shortcut commands on the prompt are:',
              '',
              'all'.ljust(5) + ' returns all code objects',
              'f'.ljust(5) + ' finds an object by its path',
              'ff'.ljust(5) + ' finds all objects given a partial path',
              'o'.ljust(5) +
                ' returns the code object for OBJECT_NAME (if present)'
            ]
          end
        end
      end
    end
  end
end
