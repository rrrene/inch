module Inch
  module CLI
    module Command
      module Output
        class Suggest < Base
          attr_reader :objects

          def initialize(options, objects, ranges, relevant_count)
            @options = options
            @objects = objects
            @ranges = ranges
            @relevant_count = relevant_count

            if objects.empty?
              # TODO: show hint
            else
              display_proper_info
              display_list
              display_files
            end
          end

          private

          def range(grade)
            @ranges.detect { |r| r.grade == grade }
          end

          def display_proper_info
            proper_size = @options.proper_grades.inject(0) do |sum,grade|
              sum + range(grade).objects.size
            end

            percent = if @relevant_count > 0
                ((proper_size/@relevant_count.to_f) * 100).to_i
              else
                0
             end
            percent = [percent, 100].min
            trace "#{proper_size} objects seem properly documented (#{percent}% of relevant objects)."
          end

          def display_list
            trace
            trace header("The following objects could be improved:", first_range.color)
            objects.each do |o|
              # this is terrible
              r = range(o.grade)
              grade = o.grade.to_s.ljust(2).method(r.color).call
              priority = o.priority
              trace edged(r.color, " #{grade} #{priority_arrow(priority, r.color)}  #{o.path}")
            end
          end

          def display_files
            trace
            trace "You might want to look at these files:".dark
            trace

            files.each do |file|
              trace edged(:dark, "#{file.dark}")
            end
            trace
          end

          def files
            arr = objects.map(&:files).map(&:first).map(&:first).flatten.uniq
            if @options.file_count
              arr[0...@options.file_count]
            else
              arr
            end
          end

          def first_range
            range(objects.first.grade)
          end

        end
      end
    end
  end
end
