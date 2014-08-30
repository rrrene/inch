module Inch
  module CLI
    # CommandParser parses a command-line arguments to decide which Command to
    # run.
    #
    # The basic form translates this shell command
    #
    #   $ inch command_name [options]
    #
    # into a method call on the corresponding Command class.
    #
    # Some examples:
    #
    #   $ inch
    #   # >>> Command::Suggest.new.run()
    #
    #   $ inch --pedantic
    #   # >>> Command::Suggest.new.run("--pedantic")
    #
    # As you can see, if no command_name is given, the {default_command}
    # will be used.
    #
    #   $ inch list --all
    #   # >>> Command::List.new.run("--all")
    #
    # If a command_name is found to match a Command, that Command will be
    # used.
    #
    #   $ inch --help
    #   # >>> CommandParser#list_commands
    #
    # The +--help+ switch is an exception and lists all available commands.
    #
    class CommandParser
      include TraceHelper

      class << self
        # @return [Hash{Symbol => Command}] the mapping of command names to
        #   command classes to parse the user command.
        attr_accessor :commands

        # @return [Symbol] the default command name to use when no options
        #   are specified or
        attr_accessor :default_command
      end

      self.commands = {}

      # Convenience method to create a new CommandParser and call {#run}
      # @return (see #run)
      def self.run(*args)
        new.run(*args)
      end

      # Runs the {Command} object matching the command name of the first
      # argument.
      # @return [Command::Base]
      def run(*args)
        if ['--help', '-h'].include?(args.join)
          list_commands
        else
          run_command(*args)
        end
      end

      private

      def commands
        self.class.commands
      end

      def list_commands
        ui.trace 'Usage: inch <command> [options]'
        ui.trace
        ui.trace 'Commands:'
        commands.keys.sort_by { |k| k.to_s }.each do |command_name|
          command = commands[command_name].new
          ui.trace format('  %-8s %s', command_name, command.description)
        end
      end

      # Runs the {Command} object matching the command name of the first
      # argument.
      # @return [Command::Base]
      def run_command(*args)
        if args.empty?
          command_name = self.class.default_command
        else
          possible_command_name = args.first.to_sym

          if commands.key?(possible_command_name)
            command_name = possible_command_name
            args.shift
          else
            command_name = self.class.default_command
          end
        end

        commands[command_name].run(*args)
      end
    end
  end
end
