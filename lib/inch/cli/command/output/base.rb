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

          def priority_arrow(priority, color = :white)
            Evaluation::PriorityRange.all.each do |range|
              return range.arrow.color(color).dark if range.include?(priority)
            end
          end

          def print_file_info(o, color)
            o.files.each do |f|
              echo "-> #{f.filename}:#{f.line_no}".color(color)
            end
            echo separator
          end

          # this is used to use Inch::Utils::BufferedIO
          def ui
            @options.ui
          end
        end
      end
    end
  end
end
