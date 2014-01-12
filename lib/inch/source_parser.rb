module Inch
  # Parses the source tree
  class SourceParser
    def self.run(*args) 
      parser = self.new
      parser.run(*args)
      parser
    end

    def all_objects
      @all_objects ||= all_parsed_objects.map do |o|
        CodeObject::Proxy.for(o)
      end.sort_by(&:path)
    end

    def find_object(path)
      all_objects.detect { |o| o.path == path }
    end
    alias :[] :find_object

    def find_objects(path)
      all_objects.select { |o| o.path.start_with?(path) }
    end

    def run(*args)
      YARD.parse(*args)
    end

    private

    def all_parsed_objects
      YARD::Registry.all
    end
  end
end
