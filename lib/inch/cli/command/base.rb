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

        attr_reader :codebase # @return [Codebase::Proxy]

        # Helper method to run an instance with the given +args+
        #
        # @see #run
        # @return [Command::Base] the instance that ran
        def self.run(*args)
          kwargs = args.last.is_a?(Hash) ? args.pop : {}
          command = new(kwargs)
          command.run(*args)
          command
        end

        # Registers the current Command in the CommandParser
        #
        # @param name [Symbol] name of the Command
        # @return [void]
        def self.register_command_as(name, default = false)
          CLI::CommandParser.default_command = name if default
          CLI::CommandParser.commands[name] = self
        end

        def initialize(kwargs = {})
          @ui = kwargs[:ui] if kwargs[:ui]
          initialize_cli_options
        end

        # Returns a description of the command
        #
        # @return [String]
        def description
          ''
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
        # @param *_args [Array<String>]
        def run(*_args)
          fail NotImplementedError
        end

        # Returns a description of the command's usage pattern
        #
        # @return [String]
        def usage
          "Usage: inch #{name} [options]"
        end

        protected

        def initialize_cli_options
          name = self.class.to_s.split('::').last
          options_class = Command::Options.const_get(name)
          @options = options_class.new
          @options.usage = usage
          @options.ui = ui
        end

        # Creates a Config::Codebase object and returns it
        # (merges relevant values of a given +options+ object before).
        #
        # @param options [Options::Base]
        # @return [Config::Codebase]
        def to_config(options)
          config = Config.for(@options.language, Dir.pwd).codebase
          config.included_files = options.paths unless options.paths.empty?
          unless options.excluded.empty?
            config.excluded_files = options.excluded
          end
          config.read_dump_file = options.read_dump_file
          config
        end
      end
    end
  end
end
