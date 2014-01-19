require 'pry'

module Inch
  module CLI
    module Command
      class Console < Base
        def description
          'Shows a console'
        end

        def usage
          'Usage: inch console [paths] [OBJECT_NAME] [options]'
        end

        def run(*args)
          @options.parse(args)
          run_source_parser(@options.paths, @options.excluded)

          @objects = find_object_names(@options.object_names)
          @object = @objects.first
          Output::Console.new(@options, @object, @objects, source_parser)
        end
      end
    end
  end
end
