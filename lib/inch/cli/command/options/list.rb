module Inch
  module CLI
    module Command
      module Options
        class List < BaseList

          def descriptions
            [
              "",
              "Lists objects that can be improved regarding their documentation ordered by their grade.",
              description_grades,
              description_arrows
            ]
          end

        end
      end
    end
  end
end
