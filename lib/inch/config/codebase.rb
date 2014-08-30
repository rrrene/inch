module Inch
  class Config
    # Stores the configuration for an individual single codebase
    class Codebase
      attr_accessor :language
      attr_accessor :included_files
      attr_accessor :excluded_files
      attr_accessor :read_dump_file

      YAML_FILE = '.inch.yml'

      def initialize(language = :ruby, included = nil, excluded = nil)
        @language = language
        @included_files = included || []
        @excluded_files = excluded || []
      end

      # Returns the contents of +dir+/.inch.yml, if present.
      # Returns nil otherwise.
      #
      # @param dir [String]
      # @return [Hash,nil]
      def self.yaml(dir)
        yaml_file = File.join(dir, YAML_FILE)
        YAML.load(File.read(yaml_file)) if File.exist?(yaml_file)
      end

      # Update this Codebase config with the given block.
      # @return [void]
      def update(&block)
        instance_eval(&block)
      end

      # Search the given +dir+ for YAML_FILE and
      # update this Codebase config with the contents if the file is found.
      #
      # @param dir [String] directory to search for the file
      # @return [void]
      def update_via_yaml(dir)
        if (yaml = self.class.yaml(dir))
          Dir.chdir(dir) do
            update_language yaml['language']
            update_files yaml['files']
          end
        end
      end

      def include_files(*files)
        @included_files.concat(files).flatten!
      end

      def exclude_files(*files)
        @excluded_files.concat(files).flatten!
      end

      # Sets the object provider (e.g. :YARD)
      #
      # @param sym [Symbol] the object provider
      # @return [Symbol] the object provider
      def object_provider(sym = nil)
        return @object_provider if sym.nil?
        @object_provider = sym
      end

      private

      def expand_files(files)
        files.map do |f|
          case f
          when String
            f =~ /[\*\{]/ ? Dir[f] : f
          else
            f
          end
        end.flatten
      end

      def update_files(files)
        return if files.nil?
        @included_files = expand_files(files['included']) if files['included']
        @excluded_files = expand_files(files['excluded']) if files['excluded']
      end

      def update_language(language)
        return if language.nil?
        @language = language
      end
    end
  end
end
