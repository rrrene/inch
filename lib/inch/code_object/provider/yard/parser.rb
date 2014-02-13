module Inch
  module CodeObject
    module Provider
      module YARD
        # Parses the source tree (using YARD)
        class Parser
          DEFAULT_PATHS     = ["app/**/*.rb", "lib/**/*.rb"]
          DEFAULT_EXCLUDED  = []

          # Helper method to parse an instance with the given +args+
          #
          # @see #parse
          # @return [CodeObject::Provider::YARD] the instance that ran
          def self.parse(*args)
            parser = self.new
            parser.parse(*args)
            parser
          end

          def parse(dir, paths, excluded)
            old_dir = Dir.pwd
            Dir.chdir dir
            ::YARD::Registry.clear
            ::YARD.parse(paths || DEFAULT_PATHS, excluded || DEFAULT_EXCLUDED)
            Dir.chdir old_dir
          end

          def objects
            parsed_objects.map do |o|
              YARD::Object.for(o)
            end
          end

          private

          def parsed_objects
            ::YARD::Registry.all
          end
        end
      end
    end
  end
end
