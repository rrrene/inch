module Inch
  module CLI
    module Command
      module Output
        class Stats < Base
          attr_reader :objects, :good_count

          def initialize(options, objects, ranges, good_count)
            @options = options
            @objects = objects
            @ranges = ranges
            @good_count = good_count

            hash = {}

            hash[:ranges] = {}
            @ranges.each do |r|
              hash[:ranges][r.grade] = r.objects.size
            end

            hash[:scores] = {}
            @objects.sort_by(&:score).each do |o|
              hash[:scores][o.score.to_i] ||= 0
              hash[:scores][o.score.to_i] += 1
            end

            hash[:priorities] = {}
            @objects.sort_by(&:priority).each do |o|
              hash[:priorities][o.priority.to_i] ||= 0
              hash[:priorities][o.priority.to_i] += 1
            end

            puts JSON.pretty_generate(hash)
          end

          private

          def display_stats
            all_size = objects.size
            @ranges.each do |range|
              size = range.objects.size
              percent = all_size > 0 ? ((size/all_size.to_f) * 100).to_i : 0
              trace "#{size.to_s.rjust(5)} objects #{percent.to_s.rjust(3)}%  #{range.description}".method(range.color).call
            end
          end

          def good_percent
            total = objects.size
            if total > 0
              percent = good_count/total.to_f
              (percent * 100).to_i
            else
              0
            end
          end
        end
      end
    end
  end
end
