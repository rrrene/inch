require 'json'
require 'yaml'

module Inch
  module CLI
    module Command
      module Output
        class Stats < Base
          include SparklineHelper

          attr_reader :objects

          def initialize(options, objects, ranges)
            @options = options
            @objects = objects
            @ranges = ranges

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
            sparkline = ranges_sparkline(@ranges).to_s(' ')
            puts
            puts 'Grade distribution: (undocumented, C, B, A)'
            puts
            puts "  Overall:  #{sparkline}  #{objects.size.to_s.rjust(5)} objects"
            puts
            puts 'Grade distribution by priority:'
            puts
            PRIORITY_MAP.each do |range, arrow|
              list = objects.select { |o| range.include?(o.priority) }
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
            @ranges.reverse.each do |range|
              list = range.objects.map(&:priority)

              priorities = {}
              (-7..7).each do |key|
                priorities[key.to_s] = list.select { |p| p == key }.size
              end

              sparkline = Sparkr::Sparkline.new(priorities.values)
              sparkline.format do |tick, count, index|
                if index < 7 # negative priorities
                  tick.blue
                elsif index == 7
                  tick.dark
                else
                  tick.cyan
                end
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

            hash['ranges'] = {}
            @ranges.each do |r|
              hash['ranges'][r.grade.to_s] = r.objects.size
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
