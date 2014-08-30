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
            A: 'Nearly perfect:',
            B: 'Properly documented, could be improved:',
            C: 'Not properly documented:',
            U: 'Undocumented:'
          }

          # @param options [Command::Options::Suggest]
          # @param relevant_objects [Array<CodeObject::Proxy>] the objects
          #   meeting the criteria defined in +options+
          # @param objects_to_display [Array<CodeObject::Proxy>]
          # @param grade_lists [Array<Evaluation::GradeList>]
          # @param files [Array<Evaluation::File>]
          def initialize(options, relevant_objects, objects_to_display,
                         grade_lists, files)
            @options = options
            @objects = objects_to_display
            @relevant_objects = relevant_objects
            @grade_lists = grade_lists
            @files = files

            if objects.empty?
              display_no_objects_hint
            else
              display_list
              display_files
              display_distribution
            end
          end

          private

          def base_dir
            "#{Dir.pwd}/"
          end

          def display_distribution
            sparkline = grades_sparkline(@relevant_objects).to_s(' ')
            ui.trace 'Grade distribution (undocumented, C, B, A):  ' + sparkline
            ui.trace
            ui.trace priority_filter_hint
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
            ui.trace
            ui.trace 'You might want to look at these files:'
            ui.trace

            files.each do |file|
              filename = file.fullname.gsub(base_dir, '')
              ui.edged(FILE_COLOR, filename.color(FILE_COLOR))
            end
            ui.trace
          end

          def display_list
            @options.grades_to_display.map do |grade|
              r = grade_list(grade)
              grade_objects = objects.select { |o| o.grade == r.grade }
              next if grade_objects.empty?
              ui.trace
              ui.header(RANGE_LABELS[r.grade.to_sym], r.color, r.bg_color)
              grade_objects.each do |o|
                grade = o.grade.to_s.ljust(2).color(r.color)
                priority = o.priority
                ui.sub(" #{grade} #{priority_arrow(priority, r.color)}  " \
                       "#{o.fullname}")
              end
            end
          end

          def display_no_objects_hint
            hint = if @options.pedantic
                     'Even by my standards.'
                   else
                     'Try --pedantic to be excessively concerned with minor ' \
                       'details and rules.'
                   end
            ui.trace 'Nothing to suggest.'.color(:green) + " #{hint}"
          end

          def min_priority_arrows
            priority_arrows_gte(@options.object_min_priority).join(' ')
          end

          def priority_arrows_gte(min_priority)
            Evaluation::PriorityRange.all.select do |priority_range|
              priority_range.priorities.min >= min_priority
            end
          end

          def grade_list(grade_symbol)
            @grade_lists.find { |r| r.grade.to_sym == grade_symbol }
          end
        end
      end
    end
  end
end
