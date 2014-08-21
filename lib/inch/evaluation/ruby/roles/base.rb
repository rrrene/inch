module Inch
  module Evaluation
    module Ruby
      module Role
        # @abstract
        class Base < Evaluation::Role
          # Returns the type of the +object+ that is being evaluated.
          def object_type
            object.class.to_s.split("::").last.gsub(/Object$/, "").downcase
          end
        end
      end
    end
  end
end
