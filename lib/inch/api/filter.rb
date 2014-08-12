module Inch
  module API
    # Filters a codebase's objects based on given options
    class Filter
      attr_reader :codebase
      attr_reader :objects
      attr_reader :grade_lists

      def initialize(codebase, options)
        @codebase = codebase
        codebase.objects.filter! Options::Filter.new(options)
        @objects = codebase.objects.to_a
        @grade_lists = @codebase.grade_lists
      end
    end
  end
end
