module Inch
  module CodeObject
    module Evaluation
      module Score
        class Base
          def initialize(object, value = nil)
            @object = object
            @value = value
          end

          def to_f
            @value.to_f
          end
        end
      end
    end
  end
end
