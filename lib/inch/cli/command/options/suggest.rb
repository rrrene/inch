module Inch
  module CLI
    module Command
      module Options
        class Suggest < BaseList
          attribute :object_count, 20
          attribute :file_count, 5

          attribute :proper_grades, [:A, :B]
          attribute :grades_to_display, [:B, :C, :U]
          attribute :object_min_priority, 0
          attribute :object_max_score, ::Inch::Evaluation::Base::MAX_SCORE

          attribute :pedantic, false

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
              "",
              "Example: " + "$ inch suggest lib/**/*.rb --pedantic".cyan,
              "",
              description_hint_grades,
              description_hint_arrows
            ]
          end

          protected

          def suggest_options(opts)
            opts.separator ""
            opts.separator "Suggest options:"

            opts.on("-n", "--objects [COUNT]", "Show COUNT objects") do |count|
              @object_count = count.to_i
            end
            opts.on("--pedantic", "Be excessively concerned with minor details and rules") do |count|
              # all objects are considered a priority
              @object_min_priority = -99
              # only objects with the highest score are omitted from the list
              @object_max_score = object_max_score - 1
              # only A-listers are regarded as 'proper'
              @proper_grades = [:A]
              @grades_to_display = [:A, :B, :C]
              @object_count = 30
              @pedantic = true
            end
          end
        end
      end
    end
  end
end
