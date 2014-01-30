module Inch
  module CLI
    # The classes in the Command namespace are controller objects for the
    # command-.line interface parsing of command-line arguments via OptionParser and converting
    # these arguments into instance attributes.
    #
    # These attributes are then read and interpreted by the Command object.
    #
    # @see Inch::CLI:Command::Suggest
    # @see Inch::CLI:Command::Options::Suggest
    # @see Inch::CLI:Command::Output::Suggest
    module Command
      # Abstract base class for CLI controllers
      #
      # @abstract
      # @note This was adapted from YARD.
      # @see https://github.com/lsegal/yard/blob/master/lib/yard/cli/command.rb
      class Base
        include TraceHelper

        attr_reader :source_parser # @return [SourceParser]

        # Helper method to run the utility on an instance
        #
        # @see #run
        # @return [Command::Base] the instance that ran
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
        #
        # @return [String]
        def description
          ""
        end

        # Returns the name of the command by which it is referenced
        # in the command list
        #
        # @return [String]
        def name
          CommandParser.commands.each do |name, klass|
            return name if klass == self.class
          end
        end

        # Returns a description of the command's usage pattern
        #
        # @return [String]
        def usage
          "Usage: inch #{name} [options]"
        end

        private

        # Returns the source parser against the given +paths+, while
        # excluding all paths given in +excluded+
        #
        # @param paths [Array<String>]
        # @param excluded [Array<String>]
        # @return [void]
        def run_source_parser(paths, excluded)
          debug "Parsing:\n" \
                "  files:    #{paths.inspect}\n" \
                "  excluded: #{excluded.inspect}"

          @source_parser = SourceParser.run(paths, excluded)
        end
      end
    end
  end
end
