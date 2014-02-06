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
          prepare_list(*args)
          Output::Stats.new(@options, objects, @grade_lists)
        end
      end
    end
  end
end
