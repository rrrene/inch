module Inch
  module CLI
    module Command
      # Base class for Command objects concerned with lists of objects
      #
      # Commands subclassing from this class are called with an optional list
      # of paths in the form:
      #
      #   $ inch COMMAND [paths] [options]
      #
      # @abstract
      class BaseList < Base
        attr_writer :objects

        def initialize
          super
          @ranges = Evaluation.new_score_ranges
        end

        # Prepares the list of objects and ranges, parsing arguments and
        # running the source parser.
        #
        # @param *args [Array<String>] the list of arguments.
        # @return [void]
        def prepare_list(*args)
          @options.parse(args)
          @options.verify
          run_source_parser(@options.paths, @options.excluded)
          filter_objects
          assign_objects_to_ranges
        end

        private

        # Assigns the objects returned by {#objects} to the score ranges in
        # +@ranges+ based on their score
        #
        def assign_objects_to_ranges
          @ranges.each do |range|
            list = objects.select { |o| range.range.include?(o.score) }
            range.objects = sort_by_priority(list)
          end
        end

        # Filters the +@objects+ based on the settings in +@options+
        #
        # @return [void]
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
            self.objects = objects.select { |o| o.depth <= @options.depth }
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

        # @return [Array<CodeObject::Proxy::Base>]
        def objects
          @objects ||= sort_by_priority(source_parser.all_objects)
        end

        # @param objects [Array<CodeObject::Proxy::Base>]
        # @return [Array<CodeObject::Proxy::Base>]
        def sort_by_priority(objects)
          objects.sort_by do |o|
            [o.priority, o.score, o.path.size]
          end.reverse
        end
      end
    end
  end
end
