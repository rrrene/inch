require 'sparkr'

module Inch
  module CLI
    module Command
      module Output
        class Suggest < Base
          include SparklineHelper

          attr_reader :objects

          RANGE_LABELS = {
            :A => "Nearly perfect:",
            :B => "Properly documented, could be improved:",
            :C => "Not properly documented:",
            :U => "Undocumented:",
          }

          def initialize(options, objects, ranges, relevant_count)
            @options = options
            @objects = objects
            @ranges = ranges
            @relevant_count = relevant_count

            if objects.empty?
              # TODO: show hint
            else
              display_list
              display_files
              display_distribution
              display_proper_info
            end
          end

          private

          def display_distribution
            sparkline = ranges_sparkline(@ranges).to_s(' ')
            puts "Grade distribution: (undocumented, C, B, A): " + sparkline
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

          def display_list
            @options.grades_to_display.map do |grade|
              r = range(grade)
              grade_objects = objects.select { |o| o.grade == r.grade }
              unless grade_objects.empty?
                trace
                trace header(RANGE_LABELS[r.grade], r.color)
                grade_objects.each do |o|
                  grade = o.grade.to_s.ljust(2).method(r.color).call
                  priority = o.priority
                  trace edged(r.color, " #{grade} #{priority_arrow(priority, r.color)}  #{o.path}")
                end
              end
            end
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
            trace "#{percent}% of priority objects (#{min_priority_arrows})" +
                    " seem properly documented."
          end

          def files
            list = files_sorted_by_objects
            if @options.file_count
              list[0...@options.file_count]
            else
              list
            end
          end

          def files_sorted_by_objects
            counts = {}
            files = []
            objects.each do |object|
              filenames = object.files.map(&:first)
              filenames.each do |f|
                counts[f] ||= 0
                counts[f] += 1
                files << f unless files.include?(f)
              end
            end
            files = files.sort_by do |f|
              counts[f]
            end.reverse
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
