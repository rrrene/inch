module Inch
  module Language
    module Elixir
      module Evaluation
        module Role
          # @abstract
          class Base < Inch::Evaluation::Role
            # Returns the type of the +object+ that is being evaluated.
            def object_type
              object.class.to_s.split('::').last.gsub(/Object$/, '').downcase
            end
          end

          # Missing is the base class for things that can be improved in the doc
          #
          class Missing < Base
            def score
              nil
            end

            # @return [Fixnum]
            #  a score that can be achieved by adding the missing thing
            #  mentioned by the role
            def potential_score
              @value.to_i
            end
          end
        end
      end
    end
  end
end
