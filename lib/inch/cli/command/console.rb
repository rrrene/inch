require 'pry'

module Inch
  module CLI
    module Command
      class Console < Base
        extend Forwardable

        def_delegators :source_parser, :all_objects, :find_object, :find_objects
        alias :f :find_object

        attr_reader :object, :objects
        alias :o :object

        def description
          'Shows a console'
        end

        def usage
          "Usage: inch console [options]"
        end

        def run(*args)
          object_name = parse_arguments_and_object_names(args)
          run_object(object_name)
        end

        private

        def run_object(object_name)
          if object_name.empty?
            @objects = []
          else
            if @object = source_parser.find_object(object_name)
              @objects = [@object]
            else
              @objects = source_parser.find_objects(object_name)
            end
          end

          binding.pry
        end

        def parse_arguments_and_object_names(args)
          parse_arguments(args)
          object_name = parse_object_names(args)
          run_source_parser(args)
          object_name
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
