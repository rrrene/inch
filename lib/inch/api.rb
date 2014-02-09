module Inch
  # The API module is the entry point for Inch's APIs
  module API
  end
end

require_relative 'api/base'
require_relative 'api/options/base'
require_relative 'api/options/filter'
require_relative 'api/options/suggest'

require_relative 'api/base'
require_relative 'api/filter'
require_relative 'api/get'
require_relative 'api/list'
require_relative 'api/suggest'
require_relative 'api/stats'
