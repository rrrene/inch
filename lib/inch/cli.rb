module Inch
  # The CLI module is tasked with the deconstruction of CLI calls
  # into API calls.
  #
  # @see Inch::API
  module CLI
    class << self
      # Returns the columns of the terminal window
      # (defaults to 80)
      # @return [Fixnum]
      def get_term_columns
        str = `stty size`
        rows_cols = str.split(' ').map(&:to_i)
        rows_cols[1]
      rescue
        80
      end
    end
    COLUMNS = get_term_columns
  end
end

require_relative 'cli/arguments'
require_relative 'cli/sparkline_helper'
require_relative 'cli/trace_helper'
require_relative 'cli/yardopts_helper'

require_relative 'cli/command'
