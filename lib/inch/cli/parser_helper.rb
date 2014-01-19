module Inch
  module CLI
    module ParserHelper
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
