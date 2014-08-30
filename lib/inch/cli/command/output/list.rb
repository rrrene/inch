module Inch
  module CLI
    module Command
      module Output
        class List < Base
          attr_reader :objects

          PER_RANGE = 10

          def initialize(options, objects, grade_lists)
            @options = options
            @objects = objects
            @grade_lists = grade_lists
            @omitted = 0

            display_list
          end

          private

          def display_list
            @grade_lists.each do |range|
              if range.objects.empty?
                # pass
              else
                ui.trace
                ui.header(range.label, range.color, range.bg_color)
                display_grade_list(range)
              end
            end

            if @omitted > 0
              ui.trace
              ui.trace "This output omitted #{@omitted} objects. ".dark +
                  'Use `--all` to display all objects.'.dark
            end
          end

          def display_grade_list(range)
            display_count = @options.show_all? ? range.objects.size : PER_RANGE
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
            ui.edged(color, msg)
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
            grade = grade.ljust(2).color(color)
            priority = object.priority
            " #{grade} #{priority_arrow(priority, color)}  #{object.fullname}"
          end

          def result_numbers(object, color)
            score = object.score.to_s
            score = score.rjust(3).color(color)
            priority = object.priority
            "#{score}  #{priority}  #{object.fullname}"
          end
        end
      end
    end
  end
end
