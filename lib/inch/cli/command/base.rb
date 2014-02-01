module Inch
  module CLI
    # The classes in the Command namespace are controller objects for the
    # command-line interface.
    #
    # A Command object is run via the class method +run+ (see {Base.run}).
    # Its parameters are the command-line arguments (typically ARGV).
    #
    # A Command object utilizes an {Options} object to interpret the command-
    # line arguments, then processes files and/or objects and finally uses an
    # {Output} object to present the results to the user.
    #
    #
    # To create a new command +Foo+ you must first subclass any of
    #
    # * Command::Base
    # * Command::BaseList
    # * Command::BaseObject
    #
    # Then you have to subclass Options and Output
    # classes as well, to finally get something like this:
    #
    # * Command::Foo
    # * Command::Options::Foo
    # * Command::Output::Foo
    #
    # For an example, take a look at the Suggest command.
    #
    # @see Inch::CLI::Command::Suggest
    # @see Inch::CLI::Command::Options::Suggest
    # @see Inch::CLI::Command::Output::Suggest
    module Command
      # Abstract base class for CLI controller objects
      #
      # @abstract Subclass and override #run to implement a new command
      # @note This was adapted from YARD
      #   https://github.com/lsegal/yard/blob/master/lib/yard/cli/command.rb
      class Base
        include TraceHelper

        attr_reader :source_parser # @return [SourceParser]

        # Helper method to run an instance with the given +args+
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

        # Runs the command with the given +args+
        #
        # @abstract
        # @note Override with implementation
        # @param *args [Array<String>]
        def run(*args)
          raise NotImplementedError
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
