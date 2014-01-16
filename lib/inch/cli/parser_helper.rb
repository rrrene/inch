module Inch
  module CLI
    module ParserHelper

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
