require 'sparkr'

module Inch
  module CLI
    module Command
      module Output
        class Suggest < Base
          include SparklineHelper

          attr_reader :objects, :files

          FILE_COLOR = :dark # TODO: store all colors somewhere
          RANGE_LABELS = {
            :A => "Nearly perfect:",
            :B => "Properly documented, could be improved:",
            :C => "Not properly documented:",
            :U => "Undocumented:",
          }

          def initialize(options, objects, relevant_objects, ranges, files)
            @options = options
            @objects = objects
            @relevant_objects = relevant_objects
            @ranges = ranges
            @files = files

            if objects.empty?
              # TODO: show hint
            else
              display_list
              display_files
              display_distribution
            end
          end

          private

          def display_distribution
            sparkline = grades_sparkline(@relevant_objects).to_s(' ')
            puts "Grade distribution (undocumented, C, B, A):  " + sparkline
            puts
            puts pedantic_hint
          end

          def pedantic_hint
            arrows = min_priority_arrows
            if @options.pedantic
              "Considering priority objects: #{arrows}".dark
            else
              "Only considering priority objects: #{arrows}".dark +
                "  (use `--pedantic` to get touchy).".dark
            end
          end

          def display_files
            trace
            trace "You might want to look at these files:"
            trace

            files.each do |filename|
              trace edged(FILE_COLOR, filename.color(FILE_COLOR))
            end
            trace
          end

          def display_list
            @options.grades_to_display.map do |grade|
              r = range(grade)
              grade_objects = objects.select { |o| o.grade == r.grade }
              unless grade_objects.empty?
                trace
                trace_header(RANGE_LABELS[r.grade], r.color, r.bg_color)
                grade_objects.each do |o|
                  grade = o.grade.to_s.ljust(2).color(r.color)
                  priority = o.priority
                  trace edged(r.color, " #{grade} #{priority_arrow(priority, r.color)}  #{o.path}")
                end
              end
            end
          end

          def min_priority_arrows
            priority_arrows_gte(@options.object_min_priority).join(' ')
          end

          def priority_arrows_gte(min_priority)
            PRIORITY_MAP.map do |range, str|
              str if range.min >= min_priority
            end.compact
          end

          def range(grade)
            @ranges.detect { |r| r.grade == grade }
          end
        end
      end
    end
  end
end
