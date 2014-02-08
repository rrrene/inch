module Inch
  module Codebase
    def self.parse(dir, paths = nil, excluded = nil)
      Proxy.new(dir, paths, excluded)
    end
  end
end

require_relative 'codebase/proxy'
require_relative 'codebase/objects'
require_relative 'codebase/source_parser'
