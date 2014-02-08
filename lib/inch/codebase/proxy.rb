module Inch
  module Codebase
    class Proxy
      attr_reader :objects

      def initialize(dir = Dir.pwd, paths = nil, excluded = nil)
        @base_dir = dir
        parse(paths, excluded)
      end

      def grade_lists
        lists = Evaluation.new_grade_lists
        lists.each do |range|
          list = objects.select { |o| range.scores.include?(o.score) }
          range.objects = Objects.sort_by_priority(list)
        end
        lists
      end

      private

      def in_path(&block)
        old_path = Dir.pwd
        Dir.chdir @base_dir
        yield
        Dir.chdir old_path
      end

      # Parses the source code of the codebase and sets +objects+
      # @return [void]
      def parse(paths, excluded)
        #in_path do
          Dir.chdir @base_dir
          source_parser = SourceParser.run(paths, excluded)
          @objects = Codebase::Objects.new(source_parser.yard_objects)
        #end
      end

    end
  end
end