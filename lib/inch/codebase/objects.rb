module Inch
  module Codebase
    class Objects
      include Enumerable
      extend Forwardable

      def_delegators :@list, :each, :empty?, :size

      # @param objects [Array<CodeObject::Proxy::Base>]
      # @return [Array<CodeObject::Proxy::Base>]
      def self.sort_by_priority(objects)
        objects.sort_by do |o|
          [o.priority, o.score, o.path.size]
        end.reverse
      end

      def initialize(objects)
        list = objects.map do |o|
          CodeObject::Proxy.for(o)
        end
        @list = self.class.sort_by_priority(list)
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
      #   # => returns the code object proxy for Foo#bar
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
      #   # => returns the code object proxies for all instance methods of Foo
      #
      # @param path [String] partial path/name of an object
      # @return [Array<CodeObject::Proxy::Base>]
      def starting_with(path)
        all.select { |o| o.path.start_with?(path) }
      end

      # Filters the +@objects+ based on the settings in +options+
      #
      # @return [Objects] a new Objects object
      def filter(options)
        objects = @list.map(&:object)
        instance = self.class.new(objects)
        instance.filter!(options)
        instance
      end

      # Filters the list based on the settings in +options+
      #
      # @return [void]
      def filter!(options)
        @list = ObjectsFilter.new(all, options).objects
      end
    end
  end
end
