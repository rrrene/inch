module Inch
  module CLI
    class << self
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

require_relative 'cli/command'
require_relative 'cli/command_parser'
