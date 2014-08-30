module Inch
  module Codebase
    class Serializer
      INCH_DB_DIR = File.join('.inch', 'db')

      def self.filename(revision)
        File.join(INCH_DB_DIR, revision)
      end

      def self.save(codebase, filename)
        content = Marshal.dump(codebase)
        FileUtils.mkdir_p(File.dirname(filename))
        File.open(filename, 'wb') { |file| file.write(content) }
      end

      def self.load(filename)
        codebase = Marshal.load(File.binread(filename))
        codebase.objects.each do |object|
          object.object_lookup = codebase.objects
        end
        codebase
      end
    end
  end
end
