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
            parse_yard_objects(paths, excluded)
            inject_base_dir(dir)
            Dir.chdir old_dir
          end

          def objects
            @objects ||= parsed_objects.map do |o|
              YARD::Object.for(o)
            end
          end

          private

          def parse_yard_objects(paths, excluded)
            ::YARD::Registry.clear
            ::YARD.parse(paths || DEFAULT_PATHS, excluded || DEFAULT_EXCLUDED)
          end

          def inject_base_dir(dir)
            objects.each do |object|
              object.base_dir = dir
            end
          end

          def parsed_objects
            ::YARD::Registry.all
          end
        end
      end
    end
  end
end
