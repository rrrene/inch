module Inch
  module API
    # Gets all objects matching the given +object_names+
    class Get < Filter
      attr_reader :object

      def initialize(codebase, object_names)
        super(codebase, {})
        @objects = find_objects_with_names(object_names)
        @object = objects.first
      end

      private

      # Returns all objects matching the given +object_names+
      #
      # @param object_names [Array<String>]
      # @return [Array<CodeObject::Proxy>]
      def find_objects_with_names(object_names)
        object_names.map do |object_name|
          if (object = codebase.objects.find(object_name))
            object
          else
            codebase.objects.starting_with(object_name)
          end
        end.flatten
      end
    end
  end
end
