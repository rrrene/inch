module Inch
  module API
    module Compare
      class CodeObjects
        def initialize(object1, object2)
          @a, @b = object1, object2
          if @a.object_id == @b.object_id
            raise "@a and @b are identical ruby objects. this is bad."
          end
        end

        def changed?
          present? && !unchanged?
        end

        def fullname
          (@a || @b).fullname
        end

        def grade
          @b.grade
        end


        def added?
          @a.nil? && !@b.nil?
        end

        def improved?
          changed? && @a.score.to_i < @b.score.to_i
        end

        def present?
          @a && @b
        end

        def removed?
          !@a.nil? && @b.nil?
        end

        def unchanged?
          present? && @a.score.to_i == @b.score.to_i
        end

        def scores
          [@a.score.to_i, @b.score.to_i]
        end
      end
    end
  end
end
