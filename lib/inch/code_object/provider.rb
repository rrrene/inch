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
    # converted into CodeObject::Proxy::Base objects that form the codebase:
    #
    #                        ::YARD::CodeObject
    #                               ↓
    #           ::Inch::CodeObject::Provider::YARD::Object::Base
    #                               ↓
    #                             (Hash)
    #                               ↓
    #                   ::Inch::CodeObject::Proxy::Base
    #
    #
    module Provider
      def self.parse(dir, config = Inch::Config.codebase, type = :YARD)
        provider_for(type).parse(dir, config)
      end

      # @return [Module]
      def self.provider_for(type)
        const_get(type)
      end
    end
  end
end

require_relative 'provider/yard'
