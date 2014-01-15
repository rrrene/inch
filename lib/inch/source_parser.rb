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

    def run(extra_files = [], paths = ["{lib,app}/**/*.rb", "ext/**/*.c"], excluded = [])
      YARD::Registry.clear
      YARD.parse(paths, excluded, ::Logger::UNKNOWN) # basically disable YARD's logging
      parse_extra_files(extra_files)
    end

    private

    def all_parsed_objects
      YARD::Registry.all + @extra_files
    end

    def parse_extra_files(files)
      globbed = files.map {|f| f.include?("*") ? Dir.glob(f) : f }.flatten
      @extra_files = globbed.map { |f| extra_file(f) }.compact
    end

    def extra_file(file)
      if File.file?(file)
        YARD::CodeObjects::ExtraFileObject.new(file)
      else
        warn "Could not find extra file: #{file}".yellow
        nil
      end
    end
  end
end
