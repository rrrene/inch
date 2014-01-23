module Inch
  module CLI
    module Command
      class BaseObject < Base
        attr_accessor :object, :objects

        def initialize
          super
          @ranges = Evaluation.new_score_ranges
        end

        # Prepares the (list of) objects, parsing arguments and
        # running the source parser.
        #
        # @param [Array<String>] args the list of arguments.
        # @return [void]
        def prepare_objects(*args)
          @options.parse(args)
          @options.verify
          run_source_parser(@options.paths, @options.excluded)

          self.objects = find_object_names(@options.object_names)
          self.object = @objects.first
        end

        private

        def find_object_names(object_names)
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
