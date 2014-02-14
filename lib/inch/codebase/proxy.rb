module Inch
  module Codebase
    class Proxy
      attr_reader :objects

      def initialize(dir = Dir.pwd, paths = nil, excluded = nil)
        @base_dir = dir
        provider = CodeObject::Provider.parse(dir, paths, excluded)
        @objects = Codebase::Objects.new(provider.objects)
      end

      def grade_lists
        lists = Evaluation.new_grade_lists
        lists.each do |range|
          list = objects.select { |o| range.scores.include?(o.score) }
          range.objects = Objects.sort_by_priority(list)
        end
        lists
      end
    end
  end
end