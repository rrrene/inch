module Inch
  module CodeObject
    # CodeObject::Proxy object represent code objects in the analaysed
    # codebase.
    #
    class Proxy
      # Returns a Proxy object for the given +code_object+
      #
      # @param language [String,Symbol]
      # @param code_object [YARD::Object::Base]
      # @param object_lookup [Codebase::Objects]
      # @return [CodeObject::Proxy]
      def self.for(language, code_object, object_lookup)
        attributes = Converter.to_hash(code_object)
        class_for(language, code_object).new(attributes, object_lookup)
      end

      extend Forwardable

      # @return [#find]
      #  an object that responds to #find to look up objects by their
      #  full name
      attr_accessor :object_lookup

      # @param object_lookup [Codebase::Objects]
      def initialize(attributes = {}, object_lookup = nil)
        @attributes = attributes
        @object_lookup = object_lookup
      end

      # Returns the attribute for the given +key+
      #
      # @param key [Symbol]
      def [](key)
        @attributes[key]
      end

      # @return [Symbol] the programming language of the code object
      def language
        fail NotImplementedError
      end

      # Used to persist the code object
      def marshal_dump
        @attributes
      end

      # Used to load a persisted code object
      def marshal_load(attributes)
        @attributes = attributes
      end

      def inspect
        "#<#{self.class}: #{fullname}>"
      end

      # Returns a Proxy class for the given +code_object+
      #
      # @param language [String,Symbol]
      # @param code_object [YARD::CodeObject]
      # @return [Class]
      def self.class_for(language, code_object)
        class_name = code_object.class.to_s.split('::').last
        Config.namespace(language, :CodeObject).const_get(class_name)
      end
      private_class_method :class_for
    end
  end
end
