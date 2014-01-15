module Inch
  module CLI
    module Command
      class Stats < List
        def description; 'Lists all objects with their results' end

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
        end
      end
    end
  end
end
