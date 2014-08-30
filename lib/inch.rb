require 'inch/version'

module Inch
end

require 'forwardable'

require 'inch/api'
require 'inch/core_ext'
require 'inch/codebase'
require 'inch/code_object'
require 'inch/evaluation'

require 'inch/language'

require 'inch/config'
require File.join(File.dirname(__FILE__), '..', 'config', 'base.rb')
require File.join(File.dirname(__FILE__), '..', 'config', 'ruby.rb')
require File.join(File.dirname(__FILE__), '..', 'config', 'nodejs.rb')
require File.join(File.dirname(__FILE__), '..', 'config', 'elixir.rb')
