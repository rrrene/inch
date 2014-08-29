module Inch
  module CodeObject
    # Provider modules "provide" a Codebase object with code objects.
    # They are the intermediary between the raw representation that tools
    # like YARD deliver and the "interface" that Inch expects.
    #
    # YARD Example:
    #
    # YARD's SourceParser returns ::YARD::CodeObject objects, which are
    # cast to Provider::YARD::Object::Base objects that can ensure naming
    # conventions et al. follow certain rules. These objects are then again
    # converted into CodeObject::Proxy objects that form the codebase:
    #
    #                        ::YARD::CodeObject
    #                               |
    #           ::Inch::CodeObject::Provider::YARD::Object::Base
    #                               |
    #                             (Hash)
    #                               |
    #                   ::Inch::CodeObject::Proxy
    #
    #
    module Provider
      # Parses a codebase to provide objects
      #
      # @param dir [String] the directory to parse
      # @param config [Inch::Config::Codebase]
      # @return [#objects]
      def self.parse(dir, config = Inch::Config.codebase)
        Config.namespace(config.language, :Provider)
          .const_get(config.object_provider)
          .parse(dir, config)
      end
    end
  end
end
