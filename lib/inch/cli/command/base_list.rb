module Inch
  module CLI
    module Command
      # Base class for Command objects concerned with lists of objects
      #
      # Commands subclassing from this class are called with an optional list
      # of paths in the form:
      #
      #   $ inch COMMAND [paths] [options]
      #
      # @abstract
      class BaseList < Base
        attr_accessor :objects

        # Prepares the list of objects and grade_lists, parsing arguments and
        # running the source parser.
        #
        # @param *args [Array<String>] the list of arguments.
        # @return [void]
        def prepare_codebase(*args)
          @options.parse(args)
          @options.verify

          @codebase = ::Inch::Codebase.parse(Dir.pwd, to_config(@options))
        end
      end
    end
  end
end
