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
      class BaseObject < BaseList
        attr_accessor :object

        # Prepares the given objects, parsing arguments and
        # running the source parser.
        #
        # @param *args [Array<String>] the list of arguments
        # @return [void]
        def prepare_objects(*args)
          prepare_codebase(*args)

          context = API::Get.new(codebase, @options.object_names)
          self.objects = context.objects
          self.object = context.object
        end
      end
    end
  end
end
