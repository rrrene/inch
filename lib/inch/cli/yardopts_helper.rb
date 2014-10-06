module Inch
  module CLI
    module YardoptsHelper
      # @return [Array<String>] list of Ruby source files to process
      attr_accessor :yard_files

      # @return [Array<String>] list of excluded paths (regexp matches)
      attr_accessor :excluded

      VALID_YARD_SWITCHES = %w(--private --no-private --protected --no-public
                               --plugin --load --safe --yardopts --no-yardopts
                               --document --no-document)

      # Parses the option and gracefully handles invalid switches
      #
      # @param [OptionParser] opts the option parser object
      # @param [Array<String>] args the arguments passed from input. This
      #   array will be modified.
      # @return [void]
      def parse_yardopts_options(_opts, args)
        wrapper = YardoptsWrapper.new

        dupped_args = args.dup
        dupped_args.delete('--help')
        dupped_args.delete_if do |arg|
          arg =~ /^\-/ && !VALID_YARD_SWITCHES.include?(arg)
        end

        if ui
          ui.debug "Sending args to YARD:\n" \
              "  args: #{dupped_args}"
        end

        wrapper.parse_arguments(*dupped_args)

        self.yard_files = wrapper.files
        self.excluded = wrapper.excluded
      end

      def yardopts_options(opts)
        wrapper = YardoptsWrapper.new
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
