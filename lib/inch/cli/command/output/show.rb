module Inch
  module CLI
    module Command
      module Output
        class Show < Base
          attr_reader :objects

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

          LJUST = 20

          def print_object(o)
            trace
            trace_header(o.path, :magenta)

            print_file_info(o)
            echo "Grade: #{grade(0)}".rjust(5)
            echo separator
            print_roles_info(o)

          end

          def print_file_info(o)
            o.files.each do |f|
              echo "-> #{f[0]}:#{f[1]}".magenta
            end
            echo separator
          end

          def print_roles_info(o)
            if o.roles.empty?
              echo "No roles assigned.".dark
            else
              o.roles.each_with_index do |role, index|
                if role.suggestion
                  echo "+".magenta + " #{role.suggestion}"
                end
              end
            end
            echo separator
          end

          def echo(msg = "")
            trace edged(:magenta, msg)
          end

          def separator
            "-".magenta * (CLI::COLUMNS - 2)
          end

          def grade(o)
            ranges ||= Evaluation.new_score_ranges
            r = ranges.detect { |r| r.range.include?(o) }
            "#{r.grade} - #{r.description}".method(r.color).call
          end
        end
      end
    end
  end
end
