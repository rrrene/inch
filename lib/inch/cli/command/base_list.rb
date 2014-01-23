module Inch
  module CLI
    module Command
      class BaseList < Base
        attr_writer :objects

        def initialize
          super
          @ranges = Evaluation.new_score_ranges
        end

        # Prepares the list of objects and ranges, parsing arguments and
        # running the source parser.
        #
        # @param [Array<String>] args the list of arguments.
        # @return [void]
        def prepare_list(*args)
          @options.parse(args)
          @options.verify
          run_source_parser(@options.paths, @options.excluded)
          filter_objects
          assign_objects_to_ranges
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
      end
    end
  end
end
