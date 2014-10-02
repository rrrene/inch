module Inch
  # The CLI module is tasked with the deconstruction of CLI calls
  # into API calls.
  #
  # @see Inch::API
  module CLI
    class << self
      # Returns the columns of the terminal window
      # (defaults to 80)
      # @param default [Fixnum] default value for columns
      # @return [Fixnum]
      def get_term_columns(default = 80)
        str = `stty size 2>&1`
        if str =~ /Invalid argument/
          default
        else
          rows_cols = str.split(' ').map(&:to_i)
          rows_cols[1] || default
        end
      rescue
        default
      end
    end
    COLUMNS = get_term_columns
  end
end

require 'inch/cli/arguments'
require 'inch/cli/sparkline_helper'
require 'inch/cli/trace_helper'
require 'inch/cli/yardopts_helper'

require 'inch/cli/command'
