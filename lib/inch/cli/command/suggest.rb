require 'inch/cli/command/options/suggest'
require 'inch/cli/command/output/suggest'

module Inch
  module CLI
    module Command
      class Suggest < List
        register_command_as :suggest, true

        EXIT_CODE_PENDING_SUGGESTIONS = 10

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
          self.objects = context.objects
          if @options.format == Options::Suggest::FORMAT_TEXT
            Output::Suggest.new(@options, context.all_objects, objects,
                                context.grade_lists, context.files)
          else
            Output::Stats.new(@options, context.all_objects, context.grade_lists)
          end
        end

        # @return [Fixnum] 10 if suggestions were found, zero otherwise
        def exit_status
          objects.empty? ? super : EXIT_CODE_PENDING_SUGGESTIONS
        end
      end
    end
  end
end
