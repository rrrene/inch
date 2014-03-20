module Inch
  module CLI
    module Command
      module Options
        class Diff < BaseObject
          def descriptions
            [
              ""
            ]
          end

          # @return [Array<String>] the revisions to be diffed
          #   nil meaning the current working dir, including untracked files
          #   since these are later parsed via `git rev-parse`, we can support
          #   notations like "HEAD" or "HEAD^^"
          def revisions
            if object_names.empty?
              ["HEAD", nil]
            else
              object_names.first.split("..")
            end
          end
        end
      end
    end
  end
end
