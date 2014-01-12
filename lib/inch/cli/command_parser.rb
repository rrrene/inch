# This was adapted from https://github.com/lsegal/yard/blob/master/lib/yard/cli/command_parser.rb
module Inch
  module CLI
    # This class parses a command name out of the +inch+ CLI command and calls
    # that command in the form:
    #
    #   $ inch command_name [options]
    #
    # If no command or arguments are specified, or if the arguments immediately
    # begin with a +--opt+ (not +--help+), the {default_command} will be used
    # (which itself defaults to +:doc+).
    #
    class CommandParser
      class << self
        # @return [Hash{Symbol => Command}] the mapping of command names to
        #   command classes to parse the user command.
        attr_accessor :commands

        # @return [Symbol] the default command name to use when no options
        #   are specified or
        attr_accessor :default_command
      end

      self.commands = {
        :list => List,
        :show => Show,
      }

      self.default_command = :list

      # Convenience method to create a new CommandParser and call {#run}
      # @return (see #run)
      def self.run(*args) new.run(*args) end

      def initialize
        log.show_backtraces = false
      end

      # Runs the {Command} object matching the command name of the first
      # argument.
      # @return [void]
      def run(*args)
        unless ['--help', '-h'].include?(args.join)
          if args.size == 0 || args.first =~ /^-/
            command_name = self.class.default_command
          else
            command_name = args.first.to_sym
            args.shift
          end
          if commands.has_key?(command_name)
            return commands[command_name].run(*args)
          end
        end
        list_commands
      end

      private

      def commands; self.class.commands end

      def list_commands
        log.puts "Usage: inch <command> [options]"
        log.puts
        log.puts "Commands:"
        commands.keys.sort_by {|k| k.to_s }.each do |command_name|
          command = commands[command_name].new
          log.puts "%-8s %s" % [command_name, command.description]
        end
      end
    end
  end
end