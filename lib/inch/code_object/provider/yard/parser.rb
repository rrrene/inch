module Inch
  module CodeObject
    module Provider
      module YARD
        # Parses the source tree (using YARD)
        class Parser
          IGNORE_TYPES      = [:macro]

          # Helper method to parse an instance with the given +args+
          #
          # @see #parse
          # @return [CodeObject::Provider::YARD] the instance that ran
          def self.parse(*args)
            parser = self.new
            parser.parse(*args)
            parser
          end

          # @param dir [String] directory
          # @param config [Inch::Config::Codebase] configuration for codebase
          # @return [void]
          def parse(dir, config)
            old_dir = Dir.pwd
            Dir.chdir dir
            parse_yard_objects(config.included_files, config.excluded_files)
            inject_base_dir(dir)
            Dir.chdir old_dir
          end

          # @return [Array<YARD::Object::Base>]
          def objects
            @objects ||= parsed_objects.map do |o|
              YARD::Object.for(o) unless IGNORE_TYPES.include?(o.type)
            end.compact
          end

          private

          def parse_yard_objects(paths, excluded)
            YARD::Object.clear_cache
            ::YARD::Registry.clear
            ::YARD.parse(paths, excluded)
          end

          def inject_base_dir(dir)
            objects.each do |object|
              object.base_dir = dir

              object.aliases_fullnames.each do |fullname|
                _alias = objects.detect { |o| o.fullname == fullname }
                _alias.aliased_object_fullname = object.fullname
              end
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
