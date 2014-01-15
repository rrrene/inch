module Inch
  module CLI
    module ParserHelper
      def run_source_parser(args)
        paths = args
        if paths.empty?
          paths = ["lib/**/*.rb", "app/**/*.rb"]
        end
        extra_files = []
        @source_parser ||= SourceParser.run(extra_files, paths, @excluded_files || [])
      end
      attr_reader :source_parser

    end
  end
end
