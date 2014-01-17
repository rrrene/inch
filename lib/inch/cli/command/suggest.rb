module Inch
  module CLI
    module Command
      class Suggest < List
        def initialize
          super
          @count = 15
          @proper_grades = [:A, :B]
          @grades_to_display = [:B, :C]
          @object_min_priority = 0
        end

        def description
          'Suggests some objects to be doucmented (better)'
        end

        def usage
          'Usage: inch suggest [paths] [options]'
        end

        # Runs the commandline utility, parsing arguments and displaying a
        # list of objects
        #
        # @param [Array<String>] args the list of arguments.
        # @return [void]
        def run(*args)
          parse_arguments(args)
          run_source_parser(args)
          filter_objects
          assign_objects_to_ranges

          display_proper_info
          display_list
        end

        private

        def assign_objects_to_ranges
          @ranges.each do |r|
            arr = objects.select do |o|
              r.range.include?(o.score)
            end
            r.objects = sort_by_priority(arr)
          end
        end

        def range(grade)
          @ranges.detect { |r| r.grade == grade }
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

        def display_proper_info
          proper_size = @proper_grades.inject(0) do |sum,grade|
            sum + range(grade).objects.size
          end
          all_size = select_by_priority(objects, @object_min_priority).size

          percent = all_size > 0 ? ((proper_size/all_size.to_f) * 100).to_i : 0
          trace
          trace " #{proper_size} objects seem properly documented (#{percent}% of relevant objects)."
        end

        def display_list
          display_objects = []
          @grades_to_display.map do |grade|
            r = range(grade)
            display_objects.concat select_by_priority(r.objects, @object_min_priority)
          end

          if display_objects.size > @count
            display_objects = display_objects[0..@count]
          elsif display_objects.size < @count
            puts "wtf"
          end

          if display_objects.size > 0
            first_range = range(display_objects.first.grade)
            trace
            trace header("The following objects could be improved:", first_range.color)
            display_objects.each do |o|
              # this is terrible
              r = range(o.grade)
              grade = o.grade.to_s.method(r.color).call
              priority = o.priority
              trace edged(r.color, "#{grade}  #{priority}  #{o.path}")
            end

            trace
            trace "Better grades equal better documentation.".dark
          end
        end

        def select_by_priority(arr, min_priority)
          arr.select { |o| o.priority >= min_priority }
        end

        def sort_by_priority(arr)
          arr.sort_by do |o|
            [o.priority, o.score]
          end.reverse
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

          opts.on("-n", "--objects [COUNT]", "Show COUNT objects") do |count|
            @count = count.to_i
          end
        end

      end
    end
  end
end
