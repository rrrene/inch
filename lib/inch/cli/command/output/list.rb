module Inch
  module CLI
    module Command
      module Output
        class List < Base
          attr_reader :objects

          PER_RANGE = 10

          def initialize(options, objects, ranges)
            @options = options
            @objects = objects
            @ranges = ranges
            @omitted = 0

            display_list
          end

          private

          def display_list
            @ranges.each do |range|
              if range.objects.empty?
                # pass
              else
                trace
                trace_header(range.description, range.color)
                display_range(range)
              end
            end

            if @omitted > 0
              trace
              trace "This output omitted #{@omitted} objects. ".dark +
                "Use `--full` to display all objects.".dark
            end
          end

          def display_range(range)
            display_count = @options.full ? range.objects.size : PER_RANGE
            list = range.objects[0...display_count]
            list.each do |o|
              echo range.color, result(o, range.color)
            end

            display_omitted_hint(range, display_count)
          end

          def display_omitted_hint(range, display_count)
            omitted = range.objects.size - display_count
            if omitted > 0
              @omitted += omitted
              echo range.color, "...  (omitting #{omitted} objects)".dark
            end
          end

          def echo(color, msg)
            trace edged(color, msg)
          end

          def result(object, color)
            if @options.numbers
              result_numbers(object, color)
            else
              result_grades(object, color)
            end
          end

          def result_grades(object, color)
            grade = object.grade.to_s
            grade = grade.ljust(2).method(color).call
            priority = object.priority
            " #{grade} #{priority_arrow(priority, color)}  #{object.path}"
          end

          def result_numbers(object, color)
            score = object.score.to_i.to_s
            score = score.rjust(3).method(color).call
            priority = object.priority
            "#{score}  #{priority}  #{object.path}"
          end

        end
      end
    end
  end
end
