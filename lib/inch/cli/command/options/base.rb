require 'optparse'

# This was adapted from https://github.com/lsegal/yard/blob/master/lib/yard/cli/command.rb
module Inch
  module CLI
    module Command
      module Options
        # Abstract base class for CLI options. Provides some helper methods for
        # the option parser
        #
        class Base
          include TraceHelper
          include YardoptsHelper

          class << self
            def attribute(name, default = nil)
              define_method(name) do
                instance_variable_get("@#{name}") || default
              end
              define_method("#{name}=") do |value|
                instance_variable_set("@#{name}", value)
              end
            end
          end

          attribute :usage, ""
          attribute :paths, []
          attribute :excluded, []

          def parse(args)
            set_options(opts)
            parse_options(opts, args)
          end

          def set_options(opts)
            common_options(opts)
          end

          protected

          DEFAULT_PATHS = ["{lib,app}/**/*.rb", "ext/**/*.c"]

          # @yard_files is assigned by YardoptsHelper#parse_yardopts_options
          def get_paths(args)
            paths = @yard_files ? @yard_files : args.dup
            if paths.empty?
              DEFAULT_PATHS
            else
              paths
            end
          end

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
            warn "Try `--help' for more information."
            exit 1
          end

          # Parses the option and handles invalid switches
          #
          # @param [OptionParser] opts the option parser object
          # @param [Array<String>] args the arguments passed from input. This
          #   array will be modified.
          # @return [void]
          def parse_options(opts, args)
            reset
            opts.parse!(args)
          rescue OptionParser::ParseError => err
            kill unrecognized_option(err)
          end

          def reset
            # color is enabled by default, can be turned of by switch --no-color
            Term::ANSIColor::coloring = true
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
end
