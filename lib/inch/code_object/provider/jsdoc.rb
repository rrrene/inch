require 'json'

module Inch
  module CodeObject
    module Provider
      # Parses the source tree (using JSDoc)
      module JSDoc
        # @see Provider.parse
        def self.parse(dir, config)
          Parser.parse(dir, config)
        end
      end
    end
  end
end

require "inch/code_object/provider/jsdoc/parser"
