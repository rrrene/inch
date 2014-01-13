require "inch/version"

module Inch
end

require_relative 'inch/core_ext'
require_relative 'inch/cli'
require_relative 'inch/source_parser'
require_relative 'inch/code_object'
require_relative 'inch/runner'

require 'yard'

alias :yard_logger :log
yard_logger.level = Logger::UNKNOWN # basically disable YARD's logging
