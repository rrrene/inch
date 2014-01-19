module Inch
  module CLI
    module Command
      module Options
        class Suggest < BaseList
          attribute :object_count, 15
          attribute :file_count, 5

          attribute :proper_grades, [:A, :B]
          attribute :grades_to_display, [:B, :C]
          attribute :object_min_priority, 0

          def set_options(opts)
            list_options(opts)
            suggest_options(opts)
            common_options(opts)

            yardopts_options(opts)
          end

          def descriptions
            [
              "",
              "Suggests objects and files that can be improved regarding their documentation.",
              description_grades,
              description_arrows
            ]
          end

          protected

          def suggest_options(opts)
            opts.separator ""
            opts.separator "Suggest options:"

            opts.on("-n", "--objects [COUNT]", "Show COUNT objects") do |count|
              @object_count = count.to_i
            end
          end
        end
      end
    end
  end
end
