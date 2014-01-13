module Inch
  module CLI
    class List < Base
      class ScoreRange < Struct.new(:range, :description, :color)
        attr_accessor :objects
      end

      def initialize
        @ranges = []
        @ranges << ScoreRange.new(80...100, "A - Good", :green)
        @ranges << ScoreRange.new(50...80, "B - Medium", :yellow)
        @ranges << ScoreRange.new(0...50, "C - Bad", :red)
      end

      def description; 'Lists all objects with their results' end

      # Runs the commandline utility, parsing arguments and displaying a
      # list of objects
      #
      # @param [Array<String>] args the list of arguments.
      # @return [void]
      def run(*args)
        parse_arguments(*args)
        filter_objects
        assign_objects_to_ranges
        if @short
          display_short_list
        else
          display_list
        end
      end

      def parse_arguments(*args)
        opts = OptionParser.new
        list_options(opts)
        common_options(opts)
        parse_options(opts, args)
      end

      def list_options(opts)
        opts.separator ""
        opts.separator "List options:"
        opts.on("--short", "Only show file counts") do |v|
          @short = true
        end

        opts.on("--only-namespaces", "Only show namespaces (classes, modules)") do
          @namespaces = :only
        end
        opts.on("--no-namespaces", "Only show namespace children (methods, constants, attributes)") do
          @namespaces = :none
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

      private

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
      end

      def assign_objects_to_ranges
        @ranges.each do |range|
          arr = objects.select { |o| range.range.include?(o.evaluation.score) }
          range.objects = arr.sort_by(&:path)
        end
      end

      def display_list
        @ranges.each do |range|
          if range.objects.empty?
            # pass
          else
            trace
            trace "      #{range.description}".ljust(CLI::COLUMNS).black.dark.bold.method("on_intense_#{range.color}").call
            range.objects.each do |o|
              score = o.evaluation.score.to_s.rjust(4).method(range.color).call
              trace "#{score}  #{o.path}"
            end
          end
        end
      end

      def display_short_list
        # TODO: provide a switch to ignore completely undocumented objects
        @ranges.each do |range|
          size = range.objects.size
          trace "#{size.to_s.rjust(5)} objects: #{range.description}".ljust(CLI::COLUMNS).method("#{range.color}").call
        end
      end

      def objects
        @objects ||= source_parser.all_objects.sort_by do |o|
          o.evaluation.score
        end.reverse
      end
      attr_writer :objects

      def source_parser
        @source_parser ||= SourceParser.run(["{lib,app}/**/*.rb", "ext/**/*.c"])
      end
    end
  end
end
