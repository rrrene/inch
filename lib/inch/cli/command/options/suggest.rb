module Inch
  module CLI
    module Command
      module Options
        class Suggest < BaseList
          attribute :count, 15
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

          protected

          def suggest_options(opts)
            opts.separator ""
            opts.separator "Suggest options:"

            opts.on("-n", "--objects [COUNT]", "Show COUNT objects") do |count|
              @count = count.to_i
            end
          end
        end
      end
    end
  end
end
