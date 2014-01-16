module Inch
  module CLI
    module Command
      class List < Base
        class ScoreRange < Struct.new(:range, :description, :color)
          # Returns code_objects that received a score with the defined +range+
          attr_accessor :objects
        end
        PER_RANGE = 10

        def initialize
          @ranges = []
          @ranges << ScoreRange.new(80..100, "A - Good", :green)
          @ranges << ScoreRange.new(50...80, "B - Medium", :yellow)
          @ranges << ScoreRange.new(0...50, "C - Bad", :red)

          @omitted = 0
          @full = false
          @visibility = [:public, :protected]
        end

        def description
          'Lists all objects with their results'
        end

        def usage
          'Usage: inch list [paths] [options]'
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
          display_list
        end

        private

        #
        # @param args [Array<String>] args the list of arguments.
        # @return [void]
        def parse_arguments(args)
          opts = OptionParser.new
          opts.banner = usage

          list_options(opts)
          common_options(opts)

          yardopts_options(opts)
          parse_yardopts_options(opts, args)

          parse_options(opts, args)
        end

        def list_options(opts)
          opts.separator ""
          opts.separator "List options:"

          opts.on("--full", "Show all objects in the output") do
            @full = true
          end

          opts.on("--only-namespaces", "Only show namespaces (classes, modules)") do
            @namespaces = :only
          end
          opts.on("--no-namespaces", "Only show namespace children (methods, constants, attributes)") do
            @namespaces = :none
          end

          opts.on("--[no-]public", "Do [not] show public objects") do |v|
            set_visibility :public, v
          end
          opts.on("--[no-]protected", "Do [not] show protected objects") do |v|
            set_visibility :protected, v
          end
          opts.on("--[no-]private", "Do [not] show private objects") do |v|
            set_visibility :private, v
          end

          opts.on("--only-undocumented", "Only show undocumented objects") do
            @undocumented = :only
          end
          opts.on("--no-undocumented", "Only show documented objects") do
            @undocumented = :none
          end

          opts.on("--depth [DEPTH]", "Only show file counts") do |depth|
            @depth = depth.to_i
          end
        end

        def assign_objects_to_ranges
          @ranges.each do |range|
            arr = objects.select { |o| range.range.include?(o.score) }
            range.objects = arr.sort_by { |o| [o.priority, o.score] }.reverse
          end
        end

        def display_list
          @ranges.each do |range|
            if range.objects.empty?
              # pass
            else
              trace
              trace_header(range.description, range.color)
              display_range(range)
            end
          end

          if @omitted > 0
            trace
            trace "This output omitted #{@omitted} objects. ".dark +
              "Use `--full` to display all objects.".dark
          end
        end

        def display_range(range)
          display_count = @full ? range.objects.size : PER_RANGE
          list = range.objects[0...display_count]
          list.each do |o|
            trace result(o, range.color)
          end

          display_omitted_hint(range, display_count)
        end

        def display_omitted_hint(range, display_count)
          omitted = range.objects.size - display_count
          if omitted > 0
            @omitted += omitted
            echo range.color, "...  (omitting #{omitted} objects)".dark
          end
        end

        def echo(color, msg)
          trace edged(color, msg)
        end

        def filter_objects
          if @namespaces == :only
            self.objects = objects.select(&:namespace?)
          end
          if @namespaces == :none
            self.objects = objects.reject(&:namespace?)
          end
          if @undocumented == :only
            self.objects = objects.select(&:undocumented?)
          end
          if @undocumented == :none
            self.objects = objects.reject(&:undocumented?)
          end
          if @depth
            self.objects = objects.select { |o| o.depth <= @depth }
          end
          self.objects = objects.select do |o|
            @visibility.include?(o.visibility)
          end
        end

        def result(object, color)
          score = object.score.to_i.to_s
          score = score.rjust(3).method(color).call
          priority = object.priority
          edged(color, "#{score}  #{priority}  #{object.path}")
        end

        def set_visibility(visibility, v)
          if v
            @visibility.push(visibility)
          else
            @visibility.delete(visibility)
          end
        end

        def objects
          @objects ||= source_parser.all_objects.sort_by do |o|
            o.score
          end.reverse
        end
        attr_writer :objects
      end
    end
  end
end
