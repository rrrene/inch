module Inch
  # Codebases are one of the building blocks of Inch's analysis (the other
  # being "code objects" inside these "codebases").
  module Codebase
    # Parses a codebase
    #
    # @param dir [String]
    # @param paths [Array<String>]
    # @param excluded [Array<String>]
    # @return [Codebase::Proxy]
    def self.parse(dir, paths = nil, excluded = nil)
      Proxy.new(dir, paths, excluded)
    end
  end
end

require_relative 'codebase/proxy'
require_relative 'codebase/objects'
require_relative 'codebase/objects_filter'
