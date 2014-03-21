module Inch
  module CLI
    module Command
      module Output
        class Diff < Base
          extend Forwardable

          attr_reader :comparer

          # @param options [Options::Diff]
          # @param comparer [API::Compare::Codebases]
          def initialize(options, comparer)
            @options = options
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
            ui.trace
            ui.trace rev_hint
            ui.trace
            ui.trace "Format: grade (before -> after), priority, and name. " \
                      "Try `--help' for more information.".dark
          end

          private

          def puts_added(o)
            grade = colored_grade(o)
            priority = o.priority
            change = "  +  ".dark + grade + "  " + priority_arrow(o.priority)
            ui.sub(" #{change}  #{o.fullname}")
          end

          def puts_improved(before, o)
            before_grade = colored_grade(before)
            grade = colored_grade(o)
            change = before_grade + " -> ".dark + grade + "  " + priority_arrow(o.priority)
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

          def rev_hint
            if @options.since_last_commit?
              "Showing changes since your last commit."
            elsif @options.since_last_push?
              "Showing changes since you last pushed."
            else
              revisions = @options.revisions
              before_rev = revisions[0]
              after_rev = revisions[1] || "now"
              "Showing changes between #{before_rev} and #{after_rev}."
            end
          end
        end
      end
    end
  end
end
