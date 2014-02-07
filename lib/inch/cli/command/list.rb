require_relative 'options/list'
require_relative 'output/list'

module Inch
  module CLI
    module Command
      class List < BaseList
        register_command_as :list

        def description
          'Lists all objects with their results'
        end

        def usage
          'Usage: inch list [paths] [options]'
        end

        # Runs the commandline utility, parsing arguments and displaying a
        # list of objects
        #
        # @param [Array<String>] args the list of arguments.
        # @return [void]
        def run(*args)
          prepare_list(*args)
          Output::List.new(@options, objects, @grade_lists)
        end
      end
    end
  end
end
