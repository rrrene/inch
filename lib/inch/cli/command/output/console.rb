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
          # @param object [CodeObject::Proxy]
          # @param objects [Array<CodeObject::Proxy>]
          # @param codebase [Codebase::Proxy]
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

          def find_objects(fullname)
            @codebase.objects.starting_with(fullname)
          end

          def find_object(fullname)
            @codebase.objects.find(fullname)
          end

          alias_method :all, :all_objects
          alias_method :ff, :find_objects
          alias_method :f, :find_object
          alias_method :o, :object

          def run
            ui.trace
            ui.header("Welcome to Inch's console", COLOR, BG_COLOR)
            ui.sub @options.usage
            @options.descriptions.each do |line|
              ui.sub line
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
