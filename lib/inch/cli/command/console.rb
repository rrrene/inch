require 'pry'

module Inch
  module CLI
    module Command
      class Console < BaseObject
        def description
          'Shows a console'
        end

        def usage
          'Usage: inch console [paths] [OBJECT_NAME] [options]'
        end

        def run(*args)
          prepare_objects(*args)
          Output::Console.new(@options, @object, @objects, source_parser)
        end
      end
    end
  end
end
