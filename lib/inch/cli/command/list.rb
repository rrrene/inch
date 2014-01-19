module Inch
  module CLI
    module Command
      class List < Base
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

          Output::List.new(@options, objects, @ranges)
        end

        private

        def assign_objects_to_ranges
          @ranges.each do |range|
            arr = objects.select { |o| range.range.include?(o.score) }
            range.objects = arr.sort_by { |o| [o.priority, o.score] }.reverse
          end
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
          if !@options.visibility.include?(:private)
            self.objects = objects.reject do |o|
              o.private_tag?
            end
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
