require 'inch/cli/command/options/suggest'
require 'inch/cli/command/output/suggest'

module Inch
  module CLI
    module Command
      class Suggest < List
        register_command_as :suggest, true

        def description
          'Suggests some objects to be documented (better)'
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
          Output::Suggest.new(@options, context.all_objects, context.objects,
                              context.grade_lists, context.files)
        end
      end
    end
  end
end
