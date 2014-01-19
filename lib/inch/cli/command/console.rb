require 'pry'

module Inch
  module CLI
    module Command
      class Console < Base
        extend Forwardable

        def_delegators :source_parser, :all_objects, :find_object, :find_objects
        alias :all :all_objects
        alias :f :find_object

        attr_reader :object, :objects
        alias :o :object

        def description
          'Shows a console'
        end

        def usage
          'Usage: inch console [paths] [OBJECT_NAME] [options]'
        end

        def run(*args)
          @options.parse(args)
          run_source_parser(@options.paths, @options.excluded)
          load_objects(@options.object_names)
          binding.pry
        end

        private

        def load_objects(object_names)
          @objects = find_object_names(object_names)
          @object = objects.first
        end
      end
    end
  end
end
