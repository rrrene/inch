require_relative 'options/inspect'
require_relative 'output/inspect'

module Inch
  module CLI
    module Command
      class Inspect < BaseObject
        CLI::CommandParser.commands[:inspect] = self

        def description
          'Inspects an object'
        end

        def usage
          'Usage: inch inspect [paths] OBJECT_NAME [[OBJECT_NAME2] ...] [options]'
        end

        def run(*args)
          prepare_objects(*args)
          Output::Inspect.new(@options, objects)
        end
      end
    end
  end
end
