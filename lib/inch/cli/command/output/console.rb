module Inch
  module CLI
    module Command
      module Output
        class Console < Base
          extend Forwardable

          attr_reader :object, :objects, :codebase

          COLOR = :color198     # magenta-ish
          BG_COLOR = :color207  # magenta-ish

          # @param options [Options::Console]
          # @param object [CodeObject::Proxy::Base]
          # @param objects [Array<CodeObject::Proxy::Base>]
          # @param source_parser [SourceParser]
          def initialize(options, object, objects, codebase)
            @options = options
            @object = object
            @objects = objects
            @codebase = codebase

            run
          end

          def all_objects
            @codebase.objects.all
          end

          def find_objects(path)
            @codebase.objects.starting_with(path)
          end

          def find_object(path)
            @codebase.objects.find(path)
          end

          alias :all :all_objects
          alias :ff :find_objects
          alias :f :find_object
          alias :o :object


          def run
            trace
            trace_header("Welcome to Inch's console", COLOR, BG_COLOR)
            trace edged(COLOR, @options.usage)
            @options.descriptions.each do |line|
              trace edged(COLOR, line)
            end
            run_pry
          end

          def run_pry
            binding.pry
          end
        end
      end
    end
  end
end
