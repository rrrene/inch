module Inch
  module CLI
    module Command
      class Suggest < List
        def description
          'Suggests some objects to be doucmented (better)'
        end

        def usage
          'Usage: inch suggest [paths] [options]'
        end

        # Runs the commandline utility, parsing arguments and displaying a
        # list of objects
        #
        # @param [Array<String>] args the list of arguments.
        # @return [void]
        def run(*args)
          @options.parse(args)

          run_source_parser(@options.paths, @options.excluded)
          filter_objects
          assign_objects_to_ranges

          display_objects = []
          @options.grades_to_display.map do |grade|
            r = range(grade)
            display_objects.concat select_by_priority(r.objects, @options.object_min_priority)
          end

          if display_objects.size > @options.object_count
            display_objects = display_objects[0..@options.object_count]
          elsif display_objects.size < @options.object_count
            # should we add objects with lower priority to fill out the
            # requested count?
          end

          Output::Suggest.new(@options, display_objects, @ranges)
        end

        def assign_objects_to_ranges
          @ranges.each do |r|
            arr = objects.select do |o|
              r.range.include?(o.score)
            end
            r.objects = sort_by_priority(arr)
          end
        end

        def range(grade)
          @ranges.detect { |r| r.grade == grade }
        end

        def select_by_priority(arr, min_priority)
          arr.select { |o| o.priority >= min_priority }
        end

        def sort_by_priority(arr)
          arr.sort_by do |o|
            [o.priority, o.score]
          end.reverse
        end

      end
    end
  end
end
