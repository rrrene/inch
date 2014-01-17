module Inch
  module CLI
    class Arguments
      attr_reader :files, :object_names, :switches

      def initialize(args)
        @files = []
        @object_names = []
        @switches = []
        parse(args)
      end

      private

      def parse(args)
        if first_non_file = args.find_index { |e| !file_or_glob?(e) }
          @files = args[0...first_non_file]
          rest = args[first_non_file..-1]
          if first_switch = rest.find_index { |e| switch?(e) }
            @object_names = rest[0...first_switch]
            @switches = rest[first_switch..-1]
          else
            # object_names only
            @object_names = rest
          end
        else
          # files only
          @files = args
        end
      end

      def file_or_glob?(f)
        if f =~ /[\*\{]/
          true
        else
          File.file?(f) || File.directory?(f)
        end
      end

      def switch?(f)
        f =~ /^\-/
      end
    end
  end
end
