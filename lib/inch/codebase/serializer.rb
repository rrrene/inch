module Inch
  module Codebase
    class Serializer
      def self.save(codebase, filename)
        content = Marshal.dump(codebase)
        FileUtils.mkdir_p( File.dirname(filename) )
        File.open(filename, 'wb') { |file| file.write(content) }
      end

      def self.load(filename)
        Marshal.load( File.binread(filename) )
      end
    end
  end
end
