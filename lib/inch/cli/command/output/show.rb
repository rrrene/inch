module Inch
  module CLI
    module Command
      module Output
        class Show < Base
          attr_reader :objects

          COLOR = :color132
          BG_COLOR = :color138
          LJUST = 20

          def initialize(options, objects)
            @options = options
            @objects = objects

            display_objects
          end

          private

          def display_objects
            objects.each do |o|
              print_object(o)
            end
          end

          def print_object(o)
            ui.trace
            ui.header(o.fullname, COLOR, BG_COLOR)

            print_file_info(o, COLOR)
            print_grade_info(o)
            print_roles_info(o)
          end

          def print_grade_info(o)
            echo "Grade: #{grade(o.score)}".rjust(5)
            echo separator
          end

          def print_roles_info(o)
            if o.roles.empty?
              echo 'No roles assigned.'.dark
            else
              o.roles.each do |role|
                next unless role.suggestion
                echo '+'.color(COLOR) + " #{role.suggestion}"
              end
            end
            echo separator
          end

          def echo(msg = '')
            ui.edged(COLOR, msg)
          end

          def separator
            '-'.color(COLOR) * (CLI::COLUMNS - 2)
          end

          def grade(score)
            grade_lists ||= Evaluation.new_grade_lists
            r = grade_lists.find { |v| v.scores.include?(score) }
            "#{r.grade} - #{r.label}".color(r.color)
          end
        end
      end
    end
  end
end
