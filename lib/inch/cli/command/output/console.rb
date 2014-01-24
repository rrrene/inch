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

          COLOR = :color198     # magenta-ish
          BG_COLOR = :color207  # magenta-ish

          def initialize(options, object, objects, source_parser)
            @options = options
            @object = object
            @objects = objects
            @source_parser = source_parser

            run
          end

          def run
            trace
            trace_header("Welcome to Inch's console", COLOR, BG_COLOR)
            trace edged(COLOR, @options.usage)
            @options.descriptions.each do |line|
              trace edged(COLOR, line)
            end
            run_pry
          end

          private

          def run_pry
            binding.pry
          end
        end
      end
    end
  end
end
