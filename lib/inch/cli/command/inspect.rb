module Inch
  module CLI
    module Command
      class Inspect < Base
        def description
          'Inspects an object'
        end

        def usage
          'Usage: inch inspect [paths] OBJECT_NAME [[OBJECT_NAME2] ...] [options]'
        end

        def run(*args)
          @options.parse(args)
          @options.verify

          run_source_parser(@options.paths, @options.excluded)

          objects = find_object_names(@options.object_names)
          Output::Inspect.new(@options, objects)
        end
      end
    end
  end
end
