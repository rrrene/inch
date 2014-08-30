module Inch
  # Codebases are one of the building blocks of Inch's analysis (the other
  # being "code objects" inside these "codebases").
  module Codebase
    # Parses a codebase
    #
    # @param dir [String]
    # @param config [Inch::Config::Codebase]
    # @return [Codebase::Proxy]
    def self.parse(dir, config)
      config.update_via_yaml(dir)
      Proxy.parse(dir, config)
    end
  end
end

require 'inch/codebase/proxy'
require 'inch/codebase/object'
require 'inch/codebase/objects'
require 'inch/codebase/objects_filter'
require 'inch/codebase/serializer'
