module Inch
  module Codebase
    class ObjectsFilter
      attr_reader :options
      def initialize(list, options)
        @list = list
        @options = options
        filter
      end

      def objects
        @list
      end

      private

      def filter
        filter_namespaces
        filter_undocumented
        filter_depth
        filter_visibility
      end

      def filter_namespaces
        if options.namespaces == :only
          @list = @list.select(&:namespace?)
        end
        if options.namespaces == :none
          @list = @list.reject(&:namespace?)
        end
      end

      def filter_undocumented
        if options.undocumented == :only
          @list = @list.select(&:undocumented?)
        end
        if options.undocumented == :none
          @list = @list.reject(&:undocumented?)
        end
      end

      def filter_depth
        if options.depth
          @list = @list.select { |o| o.depth <= options.depth }
        end
      end

      def filter_visibility
        @list = @list.select do |o|
          options.visibility.include?(o.visibility)
        end
        if !options.visibility.include?(:private)
          @list = @list.reject do |o|
            o.private_tag?
          end
        end
      end
    end
  end
end
