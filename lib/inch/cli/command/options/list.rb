module Inch
  module CLI
    module Command
      module Options
        class List < BaseList
          attribute :numbers, false

          def descriptions
            [
              "",
              "Lists objects that can be improved regarding their documentation ordered by their grade.",
              "",
              "Example: " + "$ inch list lib/**/*.rb --all".cyan,
              "",
              description_hint_grades,
              description_hint_arrows
            ]
          end

          def list_options(opts)
            super
            opts.on("--numbers", "Show numbers instead of grades and arrows") do |depth|
              @numbers = true
            end
          end
        end
      end
    end
  end
end
