module Inch
  module CLI
    module Command
      class Show < BaseObject
        def description
          'Shows an object with its results'
        end

        def usage
          'Usage: inch show [paths] OBJECT_NAME [[OBJECT_NAME2] ...] [options]'
        end

        def run(*args)
          prepare_objects(*args)
          Output::Show.new(@options, objects)
        end
      end
    end
  end
end
