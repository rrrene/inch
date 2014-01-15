require 'pry'

module Inch
  module CLI
    module Command
      class Console < Base
        extend Forwardable

        def_delegators :source_parser, :all_objects, :find_object, :find_objects
        alias :f :find_object

        def description
          'Shows a console'
        end

        def usage
          "Usage: inch console [options]"
        end

        def run(*args)
          parse_arguments(args)
          run_source_parser(args)
          binding.pry
        end

        private

        def parse_arguments(args)
          opts = OptionParser.new
          opts.banner = usage
          common_options(opts)
          parse_options(opts, args)
        end
      end
    end
  end
end
