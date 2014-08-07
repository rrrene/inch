require "json"
require "inch/code_object/provider/jsdoc/object"

module Inch
  module CodeObject
    module Provider
      module JSDoc
        # Parses the source tree (using JSDoc)
        class Parser
          attr_reader :parsed_objects

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

          # @return [Array<YARD::Object::Base>]
          def objects
            pp @parsed_objects.last
            @objects ||= parsed_objects.map do |o|
              JSDoc::Object.for(o) # unless IGNORE_TYPES.include?(o.type)
            end.compact
            puts "#{@objects.size} objects found."
            puts "Rest of implementation: coming soon -.-"
            exit 1
          end

          private

          def parse_objects(paths, excluded)
            output = %x(jsdoc --explain #{paths.join(' ')})
            @parsed_objects = JSON[output]
          end
        end
      end
    end
  end
end
