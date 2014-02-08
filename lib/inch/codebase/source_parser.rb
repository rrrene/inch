module Inch
  module Codebase
    # Parses the source tree (using YARD)
    class SourceParser
      DEFAULT_PATHS     = ["app/**/*.rb", "lib/**/*.rb"]
      DEFAULT_EXCLUDED  = []

      # Helper method to run an instance with the given +args+
      #
      # @see #run
      # @return [SourceParser] the instance that ran
      def self.run(*args)
        parser = self.new
        parser.run(*args)
        parser
      end

      def run(paths, excluded)
        YARD::Registry.clear
        YARD.parse(paths || DEFAULT_PATHS, excluded || DEFAULT_EXCLUDED)
      end

      def yard_objects
        YARD::Registry.all
      end
    end
  end
end
