module Inch
  module CLI
    module Command
      class List < Base
        PER_RANGE = 10

        def initialize
          super
          @ranges = Evaluation.new_score_ranges
          @omitted = 0
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
          @options.parse(args)
          run_source_parser(@options.paths, @options.excluded)
          filter_objects
          assign_objects_to_ranges
          display_list
        end

        private

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
          if @options.namespaces == :only
            self.objects = objects.select(&:namespace?)
          end
          if @options.namespaces == :none
            self.objects = objects.reject(&:namespace?)
          end
          if @options.undocumented == :only
            self.objects = objects.select(&:undocumented?)
          end
          if @options.undocumented == :none
            self.objects = objects.reject(&:undocumented?)
          end
          if @options.depth
            self.objects = objects.select { |o| o.depth <= @depth }
          end
          self.objects = objects.select do |o|
            @options.visibility.include?(o.visibility)
          end
        end

        def result(object, color)
          score = object.score.to_i.to_s
          score = score.rjust(3).method(color).call
          priority = object.priority
          edged(color, "#{score}  #{priority}  #{object.path}")
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
