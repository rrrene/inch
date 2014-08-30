require 'inch/cli/command/options/stats'
require 'inch/cli/command/output/stats'

module Inch
  module CLI
    module Command
      class Stats < List
        register_command_as :stats

        def description
          'Show statistics'
        end

        def usage
          'Usage: inch stats [paths] [options]'
        end

        def run(*args)
          prepare_codebase(*args)
          context = API::Stats.new(codebase, @options)
          Output::Stats.new(@options, context.objects, context.grade_lists)
        end
      end
    end
  end
end
