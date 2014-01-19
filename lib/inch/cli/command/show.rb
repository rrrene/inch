module Inch
  module CLI
    module Command
      class Show < Base
        def description
          'Shows an object with its results'
        end

        def usage
          'Usage: inch show [paths] OBJECT_NAME [options]'
        end

        def run(*args)
          @options.parse(args)
          @options.verify

          run_source_parser(@options.paths, @options.excluded)

          objects = find_object_names(@options.object_names)
          Output::Show.new(@options, objects)
        end
      end
    end
  end
end
