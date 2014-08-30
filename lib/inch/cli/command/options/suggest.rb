module Inch
  module CLI
    module Command
      module Options
        class Suggest < BaseList
          include API::Options::Suggest::DefaultAttributeValues

          attribute :object_count, DEFAULT_OBJECT_COUNT
          attribute :file_count, DEFAULT_FILE_COUNT
          attribute :proper_grades, DEFAULT_PROPER_GRADES
          attribute :grades_to_display, DEFAULT_GRADES_TO_DISPLAY
          attribute :grade_weights, DEFAULT_GRADE_WEIGHTS
          attribute :object_min_priority, DEFAULT_OBJECT_MIN_PRIORITY
          attribute :object_max_score, DEFAULT_OBJECT_MAX_SCORE

          attribute :pedantic, false

          def set_options(opts)
            list_options(opts)
            suggest_options(opts)
            common_options(opts)

            yardopts_options(opts)
          end

          def descriptions
            [
              '',
              'Suggests objects and files that can be improved regarding ' \
                'their documentation.',
              '',
              'Example: ' +
                '$ inch suggest lib/**/*.rb --pedantic'.color(:cyan),
              '',
              description_hint_grades,
              description_hint_arrows
            ]
          end

          protected

          def suggest_options(opts)
            opts.separator ''
            opts.separator 'Suggest options:'

            opts.on('-n', '--objects [COUNT]', 'Show COUNT objects') do |count|
              @object_count = count.to_i
            end
            opts.on('--pedantic',
                    'Be excessively concerned with minor details and rules') do
              # all objects are considered a priority
              @object_min_priority = -99
              # only objects with the highest score are omitted from the list
              @object_max_score = object_max_score - 1
              # only A-listers are regarded as 'proper'
              @proper_grades = [:A]
              @grades_to_display = [:A, :B, :C, :U]
              @grade_weights = [0.3, 0.3, 0.2, 0.2]
              @object_count = 30
              @pedantic = true
            end
          end
        end
      end
    end
  end
end
