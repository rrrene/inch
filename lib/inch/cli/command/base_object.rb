module Inch
  module CLI
    module Command
      # Base class for Command objects concerned with clearly specified
      # objects.
      #
      # Commands subclassing from this class are called with a list of object
      # names (most commonly only one) in the form:
      #
      #   $ inch COMMAND [paths] OBJECT_NAME [, OBJECT_NAME2, ...] [options]
      #
      # @abstract
      class BaseObject < Base
        attr_accessor :object, :objects

        def initialize
          super
          @grade_lists = Evaluation.new_grade_lists
        end

        # Prepares the given objects, parsing arguments and
        # running the source parser.
        #
        # @param *args [Array<String>] the list of arguments
        # @return [void]
        def prepare_objects(*args)
          @options.parse(args)
          @options.verify
          run_source_parser(@options.paths, @options.excluded)

          self.objects = find_objects_with_names(@options.object_names)
          self.object = @objects.first
        end

        private

        # Returns all objects matching the given +object_names+
        #
        # @param object_names [Array<String>]
        # @return [Array<CodeObject::Proxy::Base>]
        def find_objects_with_names(object_names)
          object_names.map do |object_name|
            if object = source_parser.find_object(object_name)
              object
            else
              source_parser.find_objects(object_name)
            end
          end.flatten
        end
      end
    end
  end
end
