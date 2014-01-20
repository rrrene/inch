module Inch
  module CLI
    module Command
      class Stats < List
        def description
          'Lists all objects with their results'
        end

        def usage
          'Usage: inch stats [paths] [options]'
        end

        def run(*args)
          @options.parse(args)
          run_source_parser(@options.paths, @options.excluded)
          filter_objects
          assign_objects_to_ranges

          Output::Stats.new(@options, objects, @ranges)
        end
      end
    end
  end
end
