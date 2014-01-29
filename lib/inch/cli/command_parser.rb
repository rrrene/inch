# This was adapted from https://github.com/lsegal/yard/blob/master/lib/yard/cli/command_parser.rb
module Inch
  module CLI
    # This class parses a command name out of the +inch+ CLI command and calls
    # that command in the form:
    #
    #   $ inch command_name [options]
    #
    # If no command_name is specified, the {default_command} will be used.
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

      self.commands = {
        :console => Command::Console,
        :inspect => Command::Inspect,
        :list => Command::List,
        :show => Command::Show,
        :stats => Command::Stats,
        :suggest => Command::Suggest,
      }

      self.default_command = :suggest

      # Convenience method to create a new CommandParser and call {#run}
      # @return (see #run)
      def self.run(*args)
        new.run(*args)
      end

      def initialize
        #log.show_backtraces = false
      end

      # Runs the {Command} object matching the command name of the first
      # argument.
      # @return [void]
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
        trace "Usage: inch <command> [options]"
        trace
        trace "Commands:"
        commands.keys.sort_by {|k| k.to_s }.each do |command_name|
          command = commands[command_name].new
          trace "  %-8s %s" % [command_name, command.description]
        end
      end

      def run_command(*args)
        if args.empty?
          command_name = self.class.default_command
        else
          possible_command_name = args.first.to_sym

          if commands.has_key?(possible_command_name)
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
