module Inch
  module CLI
    module ParserHelper
      # TODO: really check the last parameters if they are globs, files
      # or switches and find the object_name(s) that way
      def parse_object_names(args)
        arguments = Arguments.new(args)
        object_names = arguments.object_names
        object_names.each do |n|
          files.delete(n)
          args.delete(n)
        end
        object_names
      end

      def find_object_names(object_names)
        object_names.map do |object_name|
          if object = source_parser.find_object(object_name)
            object
          else
            source_parser.find_objects(object_name)
          end
        end.flatten
      end

      def run_source_parser(paths, excluded)
        debug "Parsing:\n" \
              "  files:    #{paths.inspect}\n" \
              "  excluded: #{excluded.inspect}"

        @source_parser = SourceParser.run(paths, excluded)
      end
      attr_reader :source_parser
    end
  end
end
