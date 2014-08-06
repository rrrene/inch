module Inch
  module API
    module Compare
      class Codebases
        def initialize(codebase1, codebase2)
          @a, @b = codebase1, codebase2
        end

        def added_objects
          comparisons.select(&:added?)
        end

        def improved_objects
          comparisons.select(&:improved?)
        end

        def degraded_objects
          comparisons.select(&:degraded?)
        end

        def removed_objects
          comparisons.select(&:removed?)
        end

        def comparisons
          __objects_names.map do |fullname|
            object1 = @a.objects.find(fullname)
            object2 = @b.objects.find(fullname)
            Compare::CodeObjects.new(object1, object2)
          end
        end

        def find(fullname)
          comparisons.find do |comparison|
            comparison.fullname == fullname
          end
        end

        private

        def __objects_names
          fullnames = @a.objects.all.map(&:fullname) +
                    @b.objects.all.map(&:fullname)
          fullnames.uniq
        end
      end
    end
  end
end
