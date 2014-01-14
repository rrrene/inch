require 'pry'

module Inch
  module CLI
    module Command
      class Console < Base
        extend Forwardable

        def_delegators :source_parser, :all_objects, :find_object, :find_objects

        def description
          'Shows a console'
        end

        def usage
          "Usage: inch console [options]"
        end

        def run(*args)
          binding.pry
        end

        private

        def source_parser
          @source_parser ||= SourceParser.run(["{lib,app}/**/*.rb", "ext/**/*.c"])
        end
      end
    end
  end
end
