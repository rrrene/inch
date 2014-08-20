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
    #                               ↓
    #           ::Inch::CodeObject::Provider::YARD::Object::Base
    #                               ↓
    #                             (Hash)
    #                               ↓
    #                   ::Inch::CodeObject::Proxy
    #
    #
    module Provider
      def self.parse(dir, config = Inch::Config.codebase)
        type = type_for(config.language)
        provider_for(type).parse(dir, config)
      end

      # @return [Module]
      def self.provider_for(type)
        const_get(type)
      end

      # Returns the name of a provider module responsible for the
      # given +language+.
      #
      # @param language [String]
      # @return [Symbol]
      def self.type_for(language)
        {
          'ruby' => :YARD,
          'nodejs' => :JSDoc
        }[language.to_s]
      end
    end
  end
end

require "inch/code_object/provider/yard"
require "inch/code_object/provider/jsdoc"
