module Inch
  module CLI
    module Command
      # Abstract base class for CLI utilities. Provides some helper methods for
      # the option parser
      #
      # @abstract
      # @note This was adapted from YARD.
      # @see https://github.com/lsegal/yard/blob/master/lib/yard/cli/command.rb
      class Base
        include TraceHelper
        include ParserHelper

        # Helper method to run the utility on an instance.
        # @see #run
        def self.run(*args)
          command = new
          command.run(*args)
          command
        end

        def initialize
          options_class = "Command::Options::#{self.class.to_s.split('::').last}"
          @options = eval(options_class).new
          @options.usage = usage
        end

        # Returns a description of the command
        # @return [String]
        def description
          ""
        end

        # Returns the name of the command by which it is referenced
        # in the command list.
        # @return [String]
        def name
          CommandParser.commands.each do |name, klass|
            return name if klass == self.class
          end
        end

        # Returns a description of the command's usage pattern
        # @return [String]
        def usage
          "Usage: inch #{name} [options]"
        end

      end
    end
  end
end
