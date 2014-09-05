require 'optparse'

module Inch
  module CLI
    module Command
      # The classes in the Command::Options namespace are concerned with
      # parsing of command-line arguments via OptionParser and converting
      # these arguments into instance attributes.
      #
      # These attributes are then read and interpreted by the Command object.
      #
      # @see Inch::CLI::Command::Suggest
      # @see Inch::CLI::Command::Options::Suggest
      module Options
        # Abstract base class for CLI options. Provides some helper methods for
        # the option parser.
        #
        # @abstract Subclass and override #set_options
        class Base
          include TraceHelper
          include YardoptsHelper

          class << self
            # Creates an attribute with an optional default value
            #
            # @param name [Symbol] the name of the attribute
            # @param default [nil] the default value of the attribute
            # @return [void]
            def attribute(name, default = nil)
              define_method(name) do
                instance_variable_get("@#{name}") || default
              end
              define_method("#{name}=") do |value|
                instance_variable_set("@#{name}", value)
              end
            end
          end

          attribute :usage, ''    # usage description for the command
          attribute :language, 'ruby'    # the programming language
          attribute :read_dump_file, nil
          attribute :paths, []    # the paths of the to-be-analysed sources
          attribute :excluded, [] # paths to be excluded from the analysis

          attr_accessor :ui

          # Parses the given +args+ "into" the current Options object
          #
          # @param args [Array<String>] command-line arguments
          # @return [void]
          def parse(args)
            opts = OptionParser.new
            opts.banner = usage

            descriptions.each do |text|
              opts.separator '  ' + text
            end

            set_options(opts)
            parse_options(opts, args)
          end

          # Sets all options for the current Options object
          #
          # @note Override to fill with individual options
          #
          # @param opts [OptionParser]
          # @return [void]
          def set_options(opts)
            common_options(opts)
          end

          # Verifies if the given options are valid
          #
          # @note Override to fill with validations
          #
          # @return [void]
          def verify
          end

          protected

          # Returns an array of descriptions that will be shown via the
          # +--help+ switch
          #
          # @note Override to fill with an array of descriptions
          #
          # @return [Array<String>]
          def descriptions
            []
          end

          # Returns a decriptive hint explaining the arrows used to represent
          # code object priorities
          #
          # @return [String]
          def description_hint_arrows
            arrows = Evaluation::PriorityRange.all.map(&:arrow).join(' ')
            "Arrows (#{arrows}) hint at the importance of the object " \
              'being documented.'
          end

          # Returns a decriptive hint explaining the arrows used to represent
          # code object grades
          #
          # @return [String]
          def description_hint_grades
            grades = Evaluation::Grade.all
            "School grades (#{grades.join(', ')}) are assigned and " \
              'displayed with each object.'
          end

          def get_paths(args)
            # @yard_files is assigned by YardoptsHelper#parse_yardopts_options
            @yard_files ? @yard_files : args.dup
          end

          # Adds a set of common options to the tail of the OptionParser
          #
          # @param [OptionParser] opts the option parser object
          # @return [void]
          def common_options(opts)
            opts.separator ''
            opts.separator 'Other options:'
            opts.on('--[no-]color', 'Run without color') do |v|
              Term::ANSIColor.coloring = v
            end
            opts.on_tail('-v', '--version', 'Show version.') do
              ui.trace "inch #{Inch::VERSION}"
              exit
            end
            opts.on_tail('-l', '--language [LANGUAGE]',
                         'Set language (elixir|nodejs|ruby).') do |language|
              @language = language
            end
            opts.on_tail('-r', '--read-from-dump [FILE]',
                         'Read objects from dump.') do |file|
              @read_dump_file = file
            end
            opts.on_tail('-h', '--help', 'Show this help.') do
              ui.trace opts
              exit
            end
          end

          # Quits the application using `exit`
          #
          # @param msg [String,nil] optional, message to be displayed
          # @return [void]
          def kill(msg = nil)
            ui.warn usage
            ui.warn msg.red unless msg.nil?
            ui.warn "Try `--help' for more information."
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

          # Resets the command-line interface before each run
          def reset
            # color is enabled by default, can be turned of by switch --no-color
            Term::ANSIColor.coloring = true
          end

          # Callback when an unrecognize option is parsed
          #
          # @param [OptionParser::ParseError] err the exception raised by the
          #   option parser
          def unrecognized_option(err)
            ui.warn "Unrecognized/#{err.message}".red
          end
        end
      end
    end
  end
end
