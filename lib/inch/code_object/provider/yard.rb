module Inch
  module CodeObject
    module Provider
      # Parses the source tree (using YARD)
      module YARD

        def self.parse(dir, config = Inch::Config.codebase)
          Parser.parse(dir, config)
        end

      end
    end
  end
end

require 'logger'
require 'yard'

log.level = ::Logger::UNKNOWN # basically disable YARD's logging

require_relative 'yard/parser'
require_relative 'yard/docstring'
require_relative 'yard/nodoc_helper'
require_relative 'yard/object'
