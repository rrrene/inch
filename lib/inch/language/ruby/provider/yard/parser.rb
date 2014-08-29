module Inch
  module Language
    module Ruby
      module Provider
        module YARD
          # Parses the source tree (using YARD)
          class Parser
            IGNORE_TYPES      = [:macro]

            # Helper method to parse an instance with the given +args+
            #
            # @see #parse
            # @return [CodeObject::Provider::YARD::Parser] the instance that ran
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
                parse_yard_objects(config.included_files,
                                   config.excluded_files,
                                   config.read_dump_file)
                inject_base_dir(dir)
              end
            end

            # @return [Array<YARD::Object::Base>]
            def objects
              @objects ||= parsed_objects.map do |o|
                YARD::Object.for(o) unless IGNORE_TYPES.include?(o.type)
              end.compact
            end

            private

            def parse_yard_objects(paths, excluded, read_dump_file = nil)
              if read_dump_file.nil?
                YARD::Object.clear_cache
                ::YARD::Registry.clear
                ::YARD.parse(paths, excluded)
              else
                puts "Ruby doesn't support the --read option."
                exit 1
              end
            end

            def inject_base_dir(dir)
              objects.each do |object|
                object.base_dir = dir

                object.aliases_fullnames.each do |fullname|
                  alias_object = objects.find { |o| o.fullname == fullname }
                  alias_object.aliased_object_fullname = object.fullname
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
end
