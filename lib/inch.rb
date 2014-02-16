require 'inch/version'

module Inch
end

require 'forwardable'

require_relative 'inch/api'
require_relative 'inch/core_ext'
require_relative 'inch/codebase'
require_relative 'inch/code_object'
require_relative 'inch/evaluation'
require_relative 'inch/cli'

require_relative 'inch/config'
require File.join(File.dirname(__FILE__), '..', 'config', 'defaults.rb')
