require 'json'
require 'inch/language/elixir/provider/parser'

module Inch
  module Language
    module Elixir
      module Provider
        # Parses the source tree (using Reader)
        module Reader
          # @see Provider.parse
          def self.parse(dir, config)
            Parser.parse(dir, config)
          end
        end
      end
    end
  end
end
