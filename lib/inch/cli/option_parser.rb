require 'optparse'
require 'optparse/time'
require 'ostruct'
require 'pathname'

module Inch
  class OptionParser
    include Inch::TraceHelper
    attr_reader :args, :options

    def initialize(args)
      @args = args
      @options = OpenStruct.new
    end

    # Returns a structure describing the options.
    #
    def parse
      set_default_options
      lookup_and_execute_require_option(args)
      parse_options
      check_mandatory! if options.check_mandatory_arguments
      options
    end

    private

    # Kills the program if any mandatory options are missing.
    #
    def check_mandatory!
      # kill "some mandatory argument is missing"
    end

    # Displays an error message and exits the program afterwards.
    #
    def kill(msg)
      trace "inch: #{msg}\nTry `inch --help' for more information."
      exit 1
    end

    # Parses the given arguments for the --require option and requires
    # it if present. This is done separately from the regular option parsing 
    # to enable the required library to modify Inch, 
    # e.g. overwrite OptionParser#parse_additional_options.
    #
    def lookup_and_execute_require_option(args)
      args.each_with_index do |v, i|
        if %w(-r --require).include?(v)
          require args[i+1]
        end
      end
    end

    def parse_options
      parser = ::OptionParser.new do |parser|
        parser.banner = "Usage: inch [options]"
        parse_specific_options(parser)
        parse_additional_options(parser)
        parse_common_options(parser)
      end
      parser.parse!(args)
    end

    def parse_additional_options(parser)
      if arr = self.class.parse_options_procs
        parser.separator ""
        parser.separator "Custom options:"
        arr.each do |proc|
          proc.(parser, options)
        end
      end
    end

    def self.parse_options_procs
      @@parse_options_procs ||= []
    end

    def self.parse_additional_options(&block)
      parse_options_procs << block
    end

    def parse_common_options(parser)
      parser.separator ""
      parser.separator "Common options:"

      parser.on("--[no-]backtrace", "Switch backtrace") do |v|
        options.backtrace = v
      end

      parser.on("-c", "--[no-]color", "Switch colors") do |v|
        options.colors = v
      end

      parser.on("-v", "--[no-]verbose", "Run verbosely") do |v|
        options.verbose = v
      end

      parser.on("-w", "--[no-]warnings", "Switch warnings") do |v|
        options.warnings = v
      end

      # No argument, shows at tail.  This will print an options summary.
      # Try it and see!
      parser.on_tail("-h", "--help", "Show this message") do
        trace parser
        exit
      end

      # Another typical switch to print the version.
      parser.on_tail("--version", "Show version") do
        trace Inch::VERSION::STRING
        exit
      end
    end

    # Parses the specific options.
    #
    def parse_specific_options(parser)
      parser.separator ""
      parser.separator "Specific options:"

      parser.on("-r", "--require [LIBRARY]", "Require library before running Inch") do |lib|
        # this block does nothing
        # require was already performed by lookup_and_execute_require_option
        # this option is here to ensure the -r switch is listed in the help option
      end
    end
    
    def set_default_options
      options.task = :list
      options.check_mandatory_arguments = true
      options.load_local_libs = true
      options.backtrace = false
      options.colors = true
      options.verbose = false
      options.warnings = true
    end

  end
end
