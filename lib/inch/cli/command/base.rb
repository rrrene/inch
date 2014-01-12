require 'optparse'
require 'term/ansicolor'

String.send(:include, Term::ANSIColor)

# This was adapted from https://github.com/lsegal/yard/blob/master/lib/yard/cli/command.rb
module Inch
  module CLI
    # Abstract base class for CLI utilities. Provides some helper methods for
    # the option parser
    #
    # @abstract
    # @since 0.6.0
    class Base
      include TraceHelper

      # Helper method to run the utility on an instance.
      # @see #run
      def self.run(*args) new.run(*args) end

      def description; '' end

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

      # Parses the option and gracefully handles invalid switches
      #
      # @param [OptionParser] opts the option parser object
      # @param [Array<String>] args the arguments passed from input. This
      #   array will be modified.
      # @return [void]
      def parse_options(opts, args)
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
