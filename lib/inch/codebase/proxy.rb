module Inch
  module Codebase
    class Proxy
      attr_reader :objects

      def initialize(provider)
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

      def self.parse(dir = Dir.pwd, paths = nil, excluded = nil)
        provider = CodeObject::Provider.parse(dir, paths, excluded)
        new(provider)
      end
    end
  end
end
