require 'json'

module Inch
  module CodeObject
    module Provider
      # Parses the source tree (using JSDoc)
      module JSDoc
        def self.parse(dir, config = Inch::Config.codebase)
          Parser.parse(dir, config)
        end
      end
    end
  end
end

require "inch/code_object/provider/jsdoc/parser"
