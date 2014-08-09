module Inch
  class Config
    # Stores the configuration for an individual single codebase
    class Codebase
      attr_reader :included_files
      attr_reader :excluded_files

      YAML_FILE = ".inch.yml"

      def initialize(included = nil, excluded = nil)
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

      def update(&block)
        instance_eval(&block)
      end

      def update_via_yaml(dir)
        if (yaml = self.class.yaml(dir))
          Dir.chdir(dir) do
            update_files yaml["files"]
          end
        end
      end

      def include_files(*files)
        @included_files.concat(files).flatten!
      end

      def exclude_files(*files)
        @excluded_files.concat(files).flatten!
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
        @included_files = expand_files(files["included"]) if files["included"]
        @excluded_files = expand_files(files["excluded"]) if files["excluded"]
      end
    end
  end
end
