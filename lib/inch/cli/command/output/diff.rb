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

            added    = @comparer.added_objects
            improved = @comparer.improved_objects
            degraded = @comparer.degraded_objects

            if added.empty? && improved.empty? && degraded.empty?
              ui.trace 'No changes.'
            else
              show(added, improved, degraded)
            end
          end

          private

          def show(added, improved, degraded)
            unless added.empty? && improved.empty?
              ui.trace
              ui.header('Added or improved:', :green)
              added.each do |compare|
                puts_added compare.after
              end
              improved.each do |compare|
                puts_improved compare.before, compare.after
              end
            end

            unless degraded.empty?
              ui.trace
              ui.header('Degraded:', :red)
              degraded.each do |compare|
                puts_degraded compare.before, compare.after
              end
            end
            ui.trace
            ui.trace rev_hint
            ui.trace
            ui.trace 'Format: grade (before -> after), priority, and name. ' \
                      "Try `--help' for options.".dark
          end

          def puts_added(o)
            grade = colored_grade(o)
            change = '  +  '.dark + grade + '  ' + priority_arrow(o.priority)
            ui.sub(" #{change}  #{o.fullname}")
          end

          def puts_improved(before, o)
            before_grade = colored_grade(before)
            grade = colored_grade(o)
            change = before_grade + ' -> '.dark + grade + '  ' +
              priority_arrow(o.priority)
            ui.sub(" #{change}  #{o.fullname}")
          end
          alias_method :puts_degraded, :puts_improved

          def colored_grade(o)
            r = grade_list(o.grade.to_sym)
            o.grade.to_s.color(r.color)
          end

          def grade_list(grade_symbol)
            @grade_lists ||= Evaluation.new_grade_lists
            @grade_lists.find { |r| r.grade.to_sym == grade_symbol }
          end

          def rev_hint
            if @options.since_last_commit?
              'Showing changes since your last commit.'
            elsif @options.since_last_push?
              'Showing changes since you last pushed.'
            else
              revisions = @options.revisions
              before_rev = revisions[0]
              after_rev = revisions[1] || 'now'
              "Showing changes between #{before_rev} and #{after_rev}."
            end
          end
        end
      end
    end
  end
end
