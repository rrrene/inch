require "optparse"

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

          def priority_arrow(priority, color = :white)
            Evaluation::PriorityRange.all.each do |range|
              if range.include?(priority)
                return range.arrow.color(color).dark
              end
            end
          end

          def print_file_info(o, _color)
            o.files.each do |f|
              echo "-> #{f.filename}:#{f.line_no}".color(_color)
            end
            echo separator
          end
        end
      end
    end
  end
end
