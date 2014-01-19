module Inch
  module CLI
    module Command
      module Output
        class Console < Base
          extend Forwardable

          attr_reader :object, :objects, :source_parser

          def_delegators :source_parser, :all_objects, :find_object, :find_objects
          alias :all :all_objects
          alias :ff :find_objects
          alias :f :find_object
          alias :o :object

          def initialize(options, object, objects, source_parser)
            @options = options
            @object = object
            @objects = objects
            @source_parser = source_parser

            run
          end

          def run
            binding.pry
          end

        end
      end
    end
  end
end
