module Inch
  module CLI
    module Command
      module Output
        class Console < Base
          extend Forwardable

          attr_reader :comparer

          # @param options [Options::Diff]
          # @param comparer [API::Compare::Codebases]
          def initialize(options, comparer)
            @comparer = comparer

            ui.trace
            ui.header("Added or improved:", :green)
            @comparer.added_objects.each do |compare|
              object = compare.after
              puts_added object
            end
            @comparer.improved_objects.each do |compare|
              puts_improved compare.before, compare.after
            end

            if !@comparer.degraded_objects.empty?
              ui.trace
              ui.header("Degraded:", :red)
              @comparer.degraded_objects.each do |compare|
                puts_degraded compare.before, compare.after
              end
            end
          end

          private

          def puts_added(o)
            grade = colored_grade(o)
            priority = o.priority
            change = "  +  ".dark + grade
            ui.sub(" #{change}  #{o.fullname}")
          end

          def puts_improved(before, o)
            before_grade = colored_grade(before)
            grade = colored_grade(o)
            priority = o.priority
            change = before_grade + " -> ".dark + grade
            ui.sub(" #{change}  #{o.fullname}")
          end
          alias :puts_degraded :puts_improved

          def colored_grade(o)
            r = grade_list(o.grade.to_sym)
            o.grade.to_s.color(r.color)
          end

          def grade_list(grade_symbol)
            @grade_lists ||= Evaluation.new_grade_lists
            @grade_lists.detect { |r| r.grade.to_sym == grade_symbol }
          end
        end
      end
    end
  end
end
