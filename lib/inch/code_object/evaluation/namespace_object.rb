module Inch
  module CodeObject
    module Evaluation
      # a namespace object can have methods and other namespace objects
      # inside itself (e.g. classes and modules)
      class NamespaceObject < Base
        DOC_SCORE = MAX_SCORE

        def evaluate
          if object.has_doc?
            add_score Score::ObjectHasDoc.new(object, DOC_SCORE)
          end
        end

        def set_max_score(default)
          if children.empty?
            @max_score = default
          else
            @max_score = children.map(&:score).min
          end
        end

        private

        def children
          @children ||= object.children.map(&:evaluation)
        end
      end
    end
  end
end
