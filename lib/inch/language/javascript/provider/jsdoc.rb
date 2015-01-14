require 'json'

module Inch
  module Language
    module JavaScript
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
end

require 'inch/language/javascript/provider/jsdoc/parser'
