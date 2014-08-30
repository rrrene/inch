require 'inch/cli/command/options/inspect'
require 'inch/cli/command/output/inspect'

module Inch
  module CLI
    module Command
      class Inspect < BaseObject
        register_command_as :inspect

        def description
          'Inspects an object'
        end

        def usage
          'Usage: inch inspect [paths] OBJECT_NAME [[OBJECT_NAME2] ...] ' \
            '[options]'
        end

        def run(*args)
          prepare_objects(*args)
          Output::Inspect.new(@options, objects)
        end
      end
    end
  end
end
