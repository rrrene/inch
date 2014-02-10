require 'optparse'

module Inch
  module CLI
    module Command
      # The classes in the Command::Output namespace act as presenter
      # objects to the classes in the Command namespace.
      #
      # They are given all the objects and data they are supposed
      # to display to the user. They do not filter the received data.
      #
      # @see Inch::CLI::Command::Suggest
      # @see Inch::CLI::Command::Output::Suggest
      module Output
        # Abstract base class for CLI output
        #
        # @abstract
        class Base
          include TraceHelper

          PRIORITY_MAP = {
              (4..99) => "\u2191", # north
              (2...4) => "\u2197", # north-east
              (0..1)  => "\u2192", # east
              (-2..-1) => "\u2198", # south-east
              (-99..-3) => "\u2193", # south-east
            }
          PRIORITY_ARROWS = PRIORITY_MAP.values

          def priority_arrow(priority, color = :white)
            PRIORITY_MAP.each do |range, str|
              if range.include?(priority)
                return str.color(color).dark
              end
            end
          end

          def print_file_info(o, _color)
            o.files.each do |f|
              echo "-> #{f[0]}:#{f[1]}".color(_color)
            end
            echo separator
          end
        end
      end
    end
  end
end
