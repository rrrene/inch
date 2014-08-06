module Inch
  module Codebase
    # ObjectsFilter can be used to filter a list of objects by given a set of
    # given +options+
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
        elsif options.namespaces == :none
          @list = @list.reject(&:namespace?)
        end
      end

      def filter_undocumented
        if options.undocumented == :only
          @list = @list.select(&:undocumented?)
        elsif options.undocumented == :none
          @list = @list.reject(&:undocumented?)
        end
      end

      def filter_depth
        @list = @list.select { |o| o.depth <= options.depth } if options.depth
      end

      def filter_visibility
        @list = @list.select do |o|
          options.visibility.include?(o.visibility)
        end
        unless options.visibility.include?(:private)
          @list = @list.reject do |o|
            o.tagged_as_private?
          end
        end
      end
    end
  end
end
