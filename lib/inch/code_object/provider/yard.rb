module Inch
  module CodeObject
    module Provider
      # Parses the source tree (using YARD)
      module YARD

        def self.parse(dir, paths, excluded)
          Parser.parse(dir, paths, excluded)
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