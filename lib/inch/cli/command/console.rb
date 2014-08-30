require 'pry'
require 'inch/cli/command/options/console'
require 'inch/cli/command/output/console'

module Inch
  module CLI
    module Command
      class Console < BaseObject
        register_command_as :console

        def description
          'Shows a console'
        end

        def usage
          'Usage: inch console [paths] [OBJECT_NAME] [options]'
        end

        def run(*args)
          prepare_objects(*args)
          Output::Console.new(@options, @object, @objects, codebase)
        end
      end
    end
  end
end
