module Inch
  module API
    module Compare
      class CodeObjects
        attr_reader :before, :after

        def initialize(object1, object2)
          @before, @after = object1, object2
          if @before.object_id == @after.object_id
            fail '@before and @after are identical ruby objects. this is bad.'
          end
        end

        def changed?
          present? && !unchanged?
        end

        def fullname
          (@before || @after).fullname
        end

        def grade
          @after.grade
        end

        def added?
          @before.nil? && !@after.nil?
        end

        def degraded?
          changed? && @before.score > @after.score
        end

        def improved?
          changed? && @before.score < @after.score
        end

        def present?
          @before && @after
        end

        def removed?
          !@before.nil? && @after.nil?
        end

        def unchanged?
          present? && @before.score == @after.score
        end

        def scores
          [@before.score, @after.score]
        end
      end
    end
  end
end
