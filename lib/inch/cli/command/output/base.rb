require 'optparse'

module Inch
  module CLI
    module Command
      module Output
        # Abstract base class for CLI output
        #
        class Base
          include TraceHelper

          PRIORITY_MAP = {
              (4..99) => "\u2191", # north
              (2...4) => "\u2197", # north-east
              (0..1)  => "\u2192", # east
              (-2..-1) => "\u2198", # south-east
              (-99..-3) => "\u2193", # south-east
            }

          def priority_arrow(priority, color = :white)
            PRIORITY_MAP.each do |range, str|
              if range.include?(priority)
                return str.method(color).call.dark
              end
            end
          end
        end
      end
    end
  end
end
