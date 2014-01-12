require "inch/version"

module Inch
  class << self
    # Returns true if Texas is run in verbose mode
    attr_accessor :verbose

    # Returns true if warnings are enabled
    attr_accessor :warnings
  end
end

require 'pp'

require_relative 'inch/cli/trace_helper'
require_relative 'inch/cli/option_parser'
require_relative 'inch/code_object'
require_relative 'inch/runner'
