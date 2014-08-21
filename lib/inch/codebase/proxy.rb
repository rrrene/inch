module Inch
  module Codebase
    class Proxy
      attr_reader :objects

      def initialize(language, provider)
        @objects = Codebase::Objects.new(language, provider.objects)
      end

      def grade_lists
        lists = Evaluation.new_grade_lists
        lists.each do |range|
          list = objects.select { |o| range.scores.include?(o.score) }
          range.objects = Objects.sort_by_priority(list)
        end
        lists
      end

      def self.parse(dir, config)
        provider = CodeObject::Provider.parse(dir, config)
        new(config.language, provider)
      end
    end
  end
end
