require "inch/version"

module Inch
end

require 'logger'
require 'yard'

require_relative 'inch/core_ext'
require_relative 'inch/cli'
require_relative 'inch/source_parser'
require_relative 'inch/code_object'
require_relative 'inch/evaluation'
require_relative 'inch/runner'
