module Inch
  module Codebase
    def self.parse(dir, paths, excluded = [])
      instance = Proxy.new(dir)
      instance.parse(paths, excluded)
      instance
    end
  end
end

require_relative 'codebase/proxy'
require_relative 'codebase/objects'
require_relative 'codebase/source_parser'
