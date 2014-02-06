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
              [213,212,211,210,210,209,209],
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
            display_text_grades
            display_text_priorities
            puts
            puts 'Try `--format json|yaml` for raw numbers.'.dark
          end

          def display_text_grades
            sparkline = grade_lists_sparkline(@grade_lists).to_s(' ')
            puts
            puts 'Grade distribution: (undocumented, C, B, A)'
            puts
            puts "  Overall:  #{sparkline}  #{objects.size.to_s.rjust(5)} objects"
            puts
            puts 'Grade distribution by priority:'
            puts
            PRIORITY_MAP.each do |priority_range, arrow|
              list = objects.select { |o| priority_range.include?(o.priority) }
              sparkline = grades_sparkline(list).to_s(' ')
              puts "        #{arrow}   #{sparkline}  " +
                    "#{list.size.to_s.rjust(5)} objects"
              puts
            end
          end

          def display_text_priorities
            puts "Priority distribution in grades: (low to high)"
            puts
            puts "      #{PRIORITY_MAP.values.reverse.join('      ')}"
            @grade_lists.reverse.each do |range|
              list = range.objects.map(&:priority)

              priorities = {}
              (-7..7).each do |key|
                priorities[key.to_s] = list.select { |p| p == key }.size
              end

              sparkline = Sparkr::Sparkline.new(priorities.values)
              sparkline.format do |tick, count, index|
                tick.color( PRIORITY_COLORS[index] )
              end
              puts "  #{range.grade}:  " + sparkline.to_s(' ') +
                    " #{range.objects.size.to_s.rjust(5)} objects"
              puts
            end
          end

          def display_json
            puts JSON.pretty_generate(stats_hash)
          end

          def display_yaml
            puts YAML.dump(stats_hash)
          end

          def stats_hash
            hash = {}

            hash['grade_lists'] = {}
            @grade_lists.each do |r|
              hash['grade_lists'][r.grade.to_s] = r.objects.size
            end

            hash['scores'] = {}
            @objects.sort_by(&:score).each do |o|
              hash['scores'][o.score.to_i] ||= 0
              hash['scores'][o.score.to_i] += 1
            end

            hash['priorities'] = {}
            @objects.sort_by(&:priority).each do |o|
              hash['priorities'][o.priority.to_i] ||= 0
              hash['priorities'][o.priority.to_i] += 1
            end

            hash
          end

        end
      end
    end
  end
end
