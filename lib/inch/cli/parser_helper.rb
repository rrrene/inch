module Inch
  module CLI
    module ParserHelper
      # TODO: really check the last parameters if they are globs, files
      # or switches and find the object_name(s) that way
      def parse_object_names(args)
        object_name = args.pop || ""
        self.files.delete(object_name)
        object_name
      end

      def run_source_parser(args)
        @source_parser = SourceParser.run(get_paths(args), @excluded || [])
      end
      attr_reader :source_parser

      DEFAULT_PATHS = ["{lib,app}/**/*.rb", "ext/**/*.c"]

      def get_paths(args)
        paths = args.dup
        paths.concat(@files) if @files
        if paths.empty?
          DEFAULT_PATHS
        else
          paths
        end
      end
    end
  end
end
