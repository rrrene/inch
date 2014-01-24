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
          prepare_list(*args)
          Output::Suggest.new(@options, display_objects, relevant_objects, @ranges, files)
        end

        def display_objects
          list = []
          @options.grades_to_display.map do |grade|
            r = range(grade)
            arr = select_by_priority(r.objects, @options.object_min_priority)
            arr = arr.select { |o| o.score <= @options.object_max_score }
            list.concat arr
          end

          list = sort_by_priority(list)

          if list.size > @options.object_count
            list = list[0..@options.object_count]
          elsif list.size < @options.object_count
            # should we add objects with lower priority to fill out the
            # requested count?
          end
          list
        end

        def files
          list = files_sorted_by_objects
          if @options.file_count
            list[0...@options.file_count]
          else
            list
          end
        end

        def files_sorted_by_objects
          counts = {}
          files = []
          objects.each do |object|
            filenames = object.files.map(&:first)
            filenames.each do |f|
              counts[f] ||= 0
              counts[f] += 1
              files << f unless files.include?(f)
            end
          end
          files = files.sort_by do |f|
            counts[f]
          end.reverse
        end

        def range(grade)
          @ranges.detect { |r| r.grade == grade }
        end

        def relevant_objects
          select_by_priority(objects, @options.object_min_priority)
        end

        def select_by_priority(arr, min_priority)
          arr.select { |o| o.priority >= min_priority }
        end

      end
    end
  end
end
