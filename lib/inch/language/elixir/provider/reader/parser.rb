require 'json'
require 'inch/language/elixir/provider/reader/object'

module Inch
  module Language
    module Elixir
      module Provider
        module Reader
          # Parses the source tree (using Reader)
          class Parser
            attr_reader :parsed_objects

            # Helper method to parse an instance with the given +args+
            #
            # @see #parse
            # @return [CodeObject::Provider::Reader::Parser] the instance that
            #   ran
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
                parse_objects(config.included_files, config.excluded_files,
                              config.read_dump_file)
              end
            end

            # @return [Array<YARD::Object::Base>]
            def objects
              @objects ||= begin
                list = parsed_objects.map do |o|
                  Reader::Object.for(o) # unless IGNORE_TYPES.include?(o.type)
                end.compact
                children_map = {}
                list.each do |object|
                  if object.parent_fullname
                    children_map[object.parent_fullname] ||= []
                    children_map[object.parent_fullname] << object.fullname
                  end
                end
                list.each do |object|
                  object.children_fullnames = children_map[object.fullname]
                end
                list
              end
            end

            private

            def parse_objects(_paths, _excluded, read_dump_file = nil)
              if read_dump_file.nil?
                fail 'Elixir analysis only works with --read-from-dump.'
              else
                output = File.read(read_dump_file, :encoding => 'utf-8')
              end
              @parsed_objects = JSON[output]['objects']
            end
          end
        end
      end
    end
  end
end
