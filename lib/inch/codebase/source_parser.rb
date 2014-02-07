module Inch
  module Codebase
    # Parses the source tree (using YARD)
    class SourceParser
      # Helper method to run an instance with the given +args+
      #
      # @see #run
      # @return [SourceParser] the instance that ran
      def self.run(*args)
        parser = self.new
        parser.run(*args)
        parser
      end

      def run(paths, excluded = [])
        YARD::Registry.clear
        YARD.parse(paths, excluded)
      end

      def yard_objects
        YARD::Registry.all
      end
    end
  end
end
