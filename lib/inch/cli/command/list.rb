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
        if args.include?('--help')
          log.puts "Usage: inch list"
        else
          assign_objects_to_ranges
          display_list
        end
      end

      private

      def assign_objects_to_ranges
        @ranges.each do |range|
          arr = objects.select { |o| range.range.include?(o.evaluation.score) }
          range.objects = arr.sort_by(&:path)
        end
      end

      def display_list
        # TODO: provide a switch to ignore completely undocumented objects
        @ranges.each do |range|
          if range.objects.empty?
            # pass
          else
            puts
            puts "      #{range.description}".ljust(CLI::COLUMNS).black.dark.bold.method("on_intense_#{range.color}").call
            range.objects.each do |o|
              score = o.evaluation.score.to_s.rjust(4).method(range.color).call
              puts "#{score}  #{o.path}"
            end
          end
        end
      end

      def objects
        @objects ||= source_parser.all_objects.sort_by do |o|
          o.evaluation.score
        end.reverse
      end

      def source_parser
        @source_parser ||= SourceParser.run(["{lib,app}/**/*.rb", "ext/**/*.c"])
      end
    end
  end
end