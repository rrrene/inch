module Inch
  module CLI
    module Command
      class Suggest < List

        def initialize
          super
          @ranges_to_display = [:B, :C]
          @object_min_priority = 1
        end

        def description
          'Suggests some objects to be doucmented (better)'
        end

        def usage
          'Usage: inch suggest [paths] [options]'
        end

        private

        def assign_objects_to_ranges
          @ranges.each do |r|
            arr = objects.select do |o|
              o.priority >= @object_min_priority && r.range.include?(o.score)
            end
            arr = arr.sort_by do |o|
              [o.priority, o.score]
            end.reverse
            r.objects = arr
          end
        end

        #
        # @param args [Array<String>] args the list of arguments.
        # @return [void]
        def parse_arguments(args)
          opts = OptionParser.new
          opts.banner = usage

          list_options(opts)
          suggest_options(opts)
          common_options(opts)

          yardopts_options(opts)
          parse_yardopts_options(opts, args)

          parse_options(opts, args)
        end

        def display_list
          trace
          trace header("The following objects could be improved:", :yellow)
          @ranges.each do |range|
            if @ranges_to_display.include?(range.grade)
              if range.objects.empty?
                # pass
              else
                display_range(range)
              end
            end
          end
        end

        def display_range(range)
          display_count = @full ? range.objects.size : PER_RANGE
          list = range.objects[0...display_count]
          list.each do |o|
            grade = range.grade.to_s.method(range.color).call
            priority = o.priority
            trace edged(range.color, "#{grade}  #{priority}  #{o.path}")
          end
        end

        def suggest_options(opts)
          opts.separator ""
          opts.separator "Suggest options:"

          # TODO: implement this
          #opts.on("-n", "--objects [COUNT]", "Show COUNT objects") do |count|
          #  @count = count.to_i
          #end
        end

      end
    end
  end
end
