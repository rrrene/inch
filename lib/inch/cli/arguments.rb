module Inch
  module CLI
    # Arguments parses given command-line arguments into the categories
    # +files+, +object_names+, and +switches+.
    #
    # @example
    #
    #   args = ["lib/*.rb", "README", "Foo", "Foo::Bar", "--color", "--all"]
    #   arguments = ::Inch::CLI::Arguments.new(args)
    #
    #   arguments.files         # => ["lib/*.rb", "README"]
    #   arguments.object_names  # => ["Foo", "Foo::Bar"]
    #   arguments.switches      # => ["--color", "--all"]
    #
    class Arguments
      attr_reader :files, :object_names, :switches

      # @param args [Array<String>]
      def initialize(args)
        @files = []
        @object_names = []
        @switches = []
        parse(args)
      end

      private

      # @param args [Array<String>]
      # @return [void]
      def parse(args)
        if (first_non_file = args.find_index { |e| !glob_or_file?(e) })
          @files = args[0...first_non_file]
          rest = args[first_non_file..-1]
          if (first_switch = rest.find_index { |e| switch?(e) })
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

      # Returns +true+ if a given String is a glob or a filename
      #
      # @example
      #
      #   glob_or_file?("lib/*.rb") # => true
      #   glob_or_file?("README")   # => true
      #   glob_or_file?("--help")   # => false
      #
      # @param f [String]
      # @return [Boolean]
      def glob_or_file?(f)
        if f =~ /[\*\{]/
          true
        else
          File.file?(f) || File.directory?(f)
        end
      end

      # Returns +true+ if a given String is an option switch
      #
      # @example
      #
      #   switch?("--help")   # => true
      #   switch?("README")   # => false
      #
      # @param f [String]
      # @return [Boolean]
      def switch?(f)
        f =~ /^\-/
      end
    end
  end
end
