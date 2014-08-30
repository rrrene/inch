module Inch
  # The API module is the entry point for Inch's APIs
  #
  # APIs are kind of "use cases" that are utilized by the CLI classes to
  # actually "do things".
  #
  # Example:
  #
  #   $ inch list lib/**/*.rb --private
  #
  # This basically calls something like this:
  #
  #   codebase = Codebase::Proxy.new(Dir.pwd, ["lib/**/*.rb"], [])
  #   options = {:visibility => [:public, :protected, :private]}
  #   context = API::List.new(codebase, options)
  #   context.objects # => Array
  #
  # The List API takes a Codebase::Proxy object and an options
  # hash or a class in API::Options and returns objects and grade_lists
  # matching that options.
  #
  module API
  end
end

require 'inch/api/options/base'
require 'inch/api/options/filter'
require 'inch/api/options/suggest'

require 'inch/api/compare'
require 'inch/api/filter'
require 'inch/api/get'
require 'inch/api/list'
require 'inch/api/suggest'
require 'inch/api/stats'
require 'inch/api/diff'
