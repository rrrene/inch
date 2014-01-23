require 'json'
require 'yaml'

module Inch
  module CLI
    module Command
      module Output
        class Stats < Base
          include SparklineHelper

          attr_reader :objects, :good_count

          def initialize(options, objects, ranges)
            @options = options
            @objects = objects
            @ranges = ranges

            method("display_#{@options.format}").call
          end

          private

          def display_text
            sparkline = ranges_sparkline(@ranges).to_s(' ')
            puts 'Grade distribution: (undocumented, C, B, A): ' + sparkline
            puts
            puts 'Try `--format json` for more detailed numbers.'.dark
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
