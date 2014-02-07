module Inch
  module Codebase
    class Objects
      include Enumerable
      extend Forwardable

      def_delegators :@list, :each, :empty?, :size

      def initialize(objects)
        @list = objects.map do |o|
          CodeObject::Proxy.for(o)
        end.sort_by(&:path)
      end

      # Returns all parsed objects as code object proxies
      #
      # @see CodeObject::Proxy.for
      # @return [Array<CodeObject::Proxy::Base>]
      def all
        @list
      end

      # Returns the object with the given +path+
      #
      # @example
      #
      #   find("Foo#bar")
      #   # => returns code object proxy for Foo#bar
      #
      # @param path [String] partial path/name of an object
      # @return [CodeObject::Proxy::Base]
      def find(path)
        all.detect { |o| o.path == path }
      end

      # Returns all objects where the +path+ starts_with the given +path+
      #
      # @example
      #
      #   find("Foo#")
      #   # => returns code object proxies for all instance methods of Foo
      #
      # @param path [String] partial path/name of an object
      # @return [Array<CodeObject::Proxy::Base>]
      def starting_with(path)
        all.select { |o| o.path.start_with?(path) }
      end
    end
  end
end
