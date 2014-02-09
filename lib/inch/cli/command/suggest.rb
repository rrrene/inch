require_relative 'options/suggest'
require_relative 'output/suggest'

module Inch
  module CLI
    module Command
      class Suggest < List
        register_command_as :suggest, true

        def description
          'Suggests some objects to be doucmented (better)'
        end

        def usage
          'Usage: inch suggest [paths] [options]'
        end

        # Runs the commandline utility, parsing arguments and displaying a
        # list of objects
        #
        # @param [Array<String>] args the list of arguments.
        # @return [void]
        def run(*args)
          prepare_codebase(*args)
          context = API::Suggest.new(codebase, @options)
          Output::Suggest.new(@options, context.objects,
            context.objects_to_display, context.grade_lists, context.files)
        end
      end
    end
  end
end
