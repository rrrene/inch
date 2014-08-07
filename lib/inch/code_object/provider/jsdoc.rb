require 'json'

module Inch
  module CodeObject
    module Provider
      # Parses the source tree (using JSDoc)
      module JSDoc
        def self.parse(dir, config = Inch::Config.codebase)
          Parser.parse(dir, config)
        end

        # Parses the source tree (using JSDoc)
        class Parser

          # Helper method to parse an instance with the given +args+
          #
          # @see #parse
          # @return [CodeObject::Provider::JSDoc::Parser] the instance that ran
          def self.parse(*args)
            parser = new
            parser.parse(*args)
            parser
          end

          # @param dir [String] directory
          # @param config [Inch::Config::Codebase] configuration for codebase
          # @return [void]
          def parse(dir, config)
            Dir.chdir(dir) do
              parse_objects(config.included_files, config.excluded_files)
            end
          end

          private

          def parse_objects(paths, excluded)
            output = %x(jsdoc --explain #{paths.join(' ')})
            data = JSON[output]
            puts "#{data.size} objects found."
            puts "Rest of implementation: coming soon -.-"
            exit 1
          end
        end
      end
    end
  end
end
