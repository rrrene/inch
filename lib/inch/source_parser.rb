module Inch
  # Parses the source tree (using YARD)
  class SourceParser
    # Helper method to run the utility on an instance
    #
    # @see #run
    # @return [SourceParser] the instance that ran
    def self.run(*args)
      parser = self.new
      parser.run(*args)
      parser
    end

    # Returns all parsed objects as code object proxies
    #
    # @see CodeObject::Proxy.for
    # @return [Array<CodeObject::Proxy::Base>]
    def all_objects
      @all_objects ||= all_parsed_objects.map do |o|
        CodeObject::Proxy.for(o)
      end.sort_by(&:path)
    end

    # Returns the object with the given +path+
    #
    # @example
    #
    #   SourceParser.find_objects("Foo#bar")
    #   # => returns code object proxy for Foo#bar
    #
    # @param path [String] partial path/name of an object
    # @return [CodeObject::Proxy::Base]
    def find_object(path)
      all_objects.detect { |o| o.path == path }
    end
    alias :[] :find_object

    # Returns all objects where the +path+ starts_with the given +path+
    #
    # @example
    #
    #   SourceParser.find_objects("Foo#")
    #   # => returns code object proxies for all instance methods of Foo
    #
    # @param path [String] partial path/name of an object
    # @return [Array<CodeObject::Proxy::Base>]
    def find_objects(path)
      all_objects.select { |o| o.path.start_with?(path) }
    end

    def run(paths, excluded = [])
      YARD::Registry.clear
      YARD.parse(paths, excluded)
    end

    private

    def all_parsed_objects
      YARD::Registry.all
    end
  end
end
