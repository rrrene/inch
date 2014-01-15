require 'optparse'

# This was adapted from https://github.com/lsegal/yard/blob/master/lib/yard/cli/command.rb
module Inch
  module CLI
    module Command
      # Abstract base class for CLI utilities. Provides some helper methods for
      # the option parser
      #
      # @abstract
      # @since 0.6.0
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

        protected

        # Adds a set of common options to the tail of the OptionParser
        #
        # @param [OptionParser] opts the option parser object
        # @return [void]
        def common_options(opts)
          opts.separator ""
          opts.separator "Other options:"
          opts.on("--[no-]color", "Run without color") do |v|
            Term::ANSIColor::coloring = v
          end
          opts.on_tail('-v', '--version', 'Show version.') do
            trace "inch #{Inch::VERSION}"
            exit
          end
          opts.on_tail('-h', '--help', 'Show this help.') do
            trace opts
            exit
          end
        end

        def kill(msg = nil)
          warn usage
          warn msg.red unless msg.nil?
          warn "Try `inch #{name} --help' for more information."
          exit 1
        end

        # Parses the option and gracefully handles invalid switches
        #
        # @param [OptionParser] opts the option parser object
        # @param [Array<String>] args the arguments passed from input. This
        #   array will be modified.
        # @return [void]
        def parse_options(opts, args)
          # color is enabled by default, can be turned of by switch --no-color
          Term::ANSIColor::coloring = true
          opts.parse!(args)
        rescue OptionParser::ParseError => err
          unrecognized_option(err)
          args.shift if args.first && args.first[0,1] != '-'
          retry
        end

        # Callback when an unrecognize option is parsed
        #
        # @param [OptionParser::ParseError] err the exception raised by the
        #   option parser
        def unrecognized_option(err)
          trace "Unrecognized/#{err.message}".red
        end
      end
    end
  end
end
