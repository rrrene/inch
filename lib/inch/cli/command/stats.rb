module Inch
  module CLI
    module Command
      class Stats < List
        GOOD_ENOUGH_THRESHOLD = 50

        def description
          'Lists all objects with their results'
        end

        def usage
          'Usage: inch stats [paths] [options]'
        end

        def run(*args)
          parse_arguments(args)
          run_source_parser(args)
          filter_objects
          assign_objects_to_ranges
          display_stats
        end

        private

        def display_stats
          all_size = objects.size
          @ranges.each do |range|
            size = range.objects.size
            percent = all_size > 0 ? ((size/all_size.to_f) * 100).to_i : 0
            trace "#{size.to_s.rjust(5)} objects #{percent.to_s.rjust(3)}%  #{range.description}".method("#{range.color}").call
          end
          good = objects.select { |o| o.score >= GOOD_ENOUGH_THRESHOLD }.size
          percent = all_size > 0 ? ((good/all_size.to_f) * 100).to_i : 0
          trace "".ljust(14) + "#{percent.to_s.rjust(3)}% seem good."
        end

      end
    end
  end
end
