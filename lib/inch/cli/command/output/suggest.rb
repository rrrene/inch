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

          # @param options [Command::Options::Suggest]
          # @param objects_to_display [Array<CodeObject::Proxy::Base>]
          # @param relevant_objects [Array<CodeObject::Proxy::Base>] the objects meeting the criteria defined in +options+
          # @param grade_lists [Array<Evaluation::GradeList>]
          # @param files [Array<Evaluation::File>]
          def initialize(options, objects_to_display, relevant_objects, grade_lists, files)
            @options = options
            @objects = objects_to_display
            @relevant_objects = relevant_objects
            @grade_lists = grade_lists
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
            puts priority_filter_hint
          end

          def priority_filter_hint
            arrows = min_priority_arrows
            pretext = if @options.pedantic
              "Considering priority objects: #{arrows}"
            else
              "Only considering priority objects: #{arrows}"
            end
            "#{pretext}  (use `--help` for options).".dark
          end

          def display_files
            trace
            trace "You might want to look at these files:"
            trace

            files.each do |f|
              trace edged(FILE_COLOR, f.path.color(FILE_COLOR))
            end
            trace
          end

          def display_list
            @options.grades_to_display.map do |grade|
              r = grade_list(grade)
              grade_objects = objects.select { |o| o.grade == r.grade }
              unless grade_objects.empty?
                trace
                trace_header(RANGE_LABELS[r.grade.to_sym], r.color, r.bg_color)
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

          def grade_list(grade_symbol)
            @grade_lists.detect { |r| r.grade.to_sym == grade_symbol }
          end
        end
      end
    end
  end
end
