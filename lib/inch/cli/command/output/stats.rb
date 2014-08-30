require 'json'
require 'yaml'

module Inch
  module CLI
    module Command
      module Output
        class Stats < Base
          include SparklineHelper

          attr_reader :objects

          PRIORITY_COLORS = [
            [213, 212, 211, 210, 210, 209, 209],
            [177],
            [203, 203, 204, 204, 205, 206, 207]
          ].flatten.map { |s| :"color#{s}" }

          def initialize(options, objects, grade_lists)
            @options = options
            @objects = objects
            @grade_lists = grade_lists

            method("display_#{@options.format}").call
          end

          private

          def display_text
            print_grades
            print_grades_by_priority
            print_priorities
            ui.trace
            ui.trace 'Try `--format json|yaml` for raw numbers.'.dark
          end

          def print_grades
            sparkline = grade_lists_sparkline(@grade_lists).to_s(' ')
            ui.trace
            ui.trace 'Grade distribution: (undocumented, C, B, A)'
            ui.trace
            ui.trace "  Overall:  #{sparkline}  #{objects.size.to_s.rjust(5)} " \
              'objects'
            ui.trace
          end

          def print_grades_by_priority
            ui.trace 'Grade distribution by priority:'
            ui.trace
            Evaluation::PriorityRange.all.each do |priority_range|
              list = objects.select { |o| priority_range.include?(o.priority) }
              sparkline = grades_sparkline(list).to_s(' ')
              ui.trace "        #{priority_range.arrow}   #{sparkline}  " \
                    "#{list.size.to_s.rjust(5)} objects"
              ui.trace
            end
          end

          def print_grade_list(grade_list)
            list = grade_list.objects.map(&:priority)

            priorities = {}
            (-7..7).each do |key|
              priorities[key.to_s] = list.select { |p| p == key }.size
            end

            sparkline = Sparkr::Sparkline.new(priorities.values)
            sparkline.format do |tick, _count, index|
              tick.color(PRIORITY_COLORS[index])
            end
            ui.trace "  #{grade_list.grade}:  " + sparkline.to_s(' ') +
                  " #{grade_list.objects.size.to_s.rjust(5)} objects"
            ui.trace
          end

          def print_priorities
            arrows = Evaluation::PriorityRange.all.map(&:arrow)
            ui.trace 'Priority distribution in grades: (low to high)'
            ui.trace
            ui.trace "      #{arrows.reverse.join('      ')}"
            @grade_lists.reverse.each do |grade_list|
              print_grade_list(grade_list)
            end
          end

          def display_json
            ui.trace JSON.pretty_generate(stats_hash)
          end

          def display_yaml
            ui.trace YAML.dump(stats_hash)
          end

          def stats_hash
            {
              'grade_lists' => __grade_lists,
              'scores' => __scores,
              'priorities' => __priorities
            }
          end

          def __grade_lists
            hash = {}
            @grade_lists.each do |r|
              hash[r.grade.to_s] = r.objects.size
            end
            hash
          end

          def __scores
            hash = {}
            @objects.sort_by(&:score).each do |o|
              hash[o.score] ||= 0
              hash[o.score] += 1
            end
            hash
          end

          def __priorities
            hash = {}
            @objects.sort_by(&:priority).each do |o|
              hash[o.priority.to_i] ||= 0
              hash[o.priority.to_i] += 1
            end
            hash
          end
        end
      end
    end
  end
end
