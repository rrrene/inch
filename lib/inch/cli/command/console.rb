require 'pry'

module Inch
  module CLI
    module Command
      class Console < Base
        extend Forwardable

        def_delegators :source_parser, :all_objects, :find_object, :find_objects
        alias :all :all_objects
        alias :f :find_object

        attr_reader :object, :objects
        alias :o :object

        def description
          'Shows a console'
        end

        def usage
          'Usage: inch console [paths] [OBJECT_NAME] [options]'
        end

        def run(*args)
          object_names = parse_arguments_and_object_names(args)
          run_objects(object_names)
          binding.pry
        end

        private

        def run_objects(object_names)
          @objects = find_object_names(object_names)
          @object = objects.first
        end

        def parse_arguments_and_object_names(args)
          parse_arguments(args)
          object_names = parse_object_names(args)
          run_source_parser(args)
          object_names
        end

        def parse_arguments(args)
          opts = OptionParser.new
          opts.banner = usage
          common_options(opts)

          yardopts_options(opts)
          parse_yardopts_options(opts, args)

          parse_options(opts, args)
        end
      end
    end
  end
end
