module Inch
  module CLI
    module YardoptsHelper
      # @return [Array<String>] list of Ruby source files to process
      attr_accessor :files

      # @return [Array<String>] list of excluded paths (regexp matches)
      attr_accessor :excluded

      # Parses the option and gracefully handles invalid switches
      #
      # @param [OptionParser] opts the option parser object
      # @param [Array<String>] args the arguments passed from input. This
      #   array will be modified.
      # @return [void]
      def parse_yardopts_options(opts, args)
        wrapper = YardoptsWrapper.new()

        dupped_args = args.dup
        dupped_args.delete("--help")
        wrapper.parse_arguments(*dupped_args)

        debug "Using yardopts\n" \
              "  files:    #{wrapper.files}\n" \
              "  excluded: #{wrapper.excluded}"

        self.files = wrapper.files
        self.excluded = wrapper.excluded
      end

      def yardopts_options(opts)
        wrapper = YardoptsWrapper.new()
        wrapper.add_yardoc_options(opts)
      end

      class YardoptsWrapper < YARD::CLI::Yardoc
        def add_yardoc_options(opts)
          yardopts_options(opts)
        end
      end
    end
  end
end
