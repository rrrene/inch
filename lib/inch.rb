require 'inch/version'

module Inch
end

require 'forwardable'

require 'inch/api'
require 'inch/core_ext'
require 'inch/codebase'
require 'inch/code_object'
require 'inch/evaluation'

require 'inch/config'
require File.join(File.dirname(__FILE__), '..', 'config', 'defaults.rb')
