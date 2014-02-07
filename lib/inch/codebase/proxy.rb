module Inch
  module Codebase
    class Proxy
      attr_reader :objects

      def initialize(path = Dir.pwd)
        @path = path
      end

      def parse(paths, excluded = [])
        #in_path do
          Dir.chdir @path
          source_parser = SourceParser.run(paths, excluded)
          @objects = Objects.new(source_parser.yard_objects)
        #end
      end

      private

      def in_path(&block)
        old_path = Dir.pwd
        Dir.chdir @path
        yield
        Dir.chdir old_path
      end
    end
  end
end