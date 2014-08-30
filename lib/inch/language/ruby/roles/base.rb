module Inch
  module Language
    module Ruby
      module Evaluation
        module Role
          # @abstract
          class Base < Inch::Evaluation::Role
            # Returns the type of the +object+ that is being evaluated.
            def object_type
              object.class.to_s.split('::').last.gsub(/Object$/, '').downcase
            end
          end
        end
      end
    end
  end
end
