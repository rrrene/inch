require 'pry'
require 'inch/cli/command/options/diff'
require 'inch/cli/command/output/diff'

module Inch
  module CLI
    module Command
      class Diff < Base
        include Utils::ShellHelper

        register_command_as :diff

        def description
          'Shows a diff'
        end

        def usage
          'Usage: inch diff [REV..[REV]] [options]'
        end

        def run(*args)
          @options.parse(args)
          @options.verify

          before_rev, after_rev = revisions[0], revisions[1]
          diff = API::Diff.new(work_dir, to_config(@options),
                               before_rev, after_rev)

          Output::Diff.new(@options, diff.comparer)
        end

        private

        # @return [Array<String>] the revisions passed in the command_line
        def revisions
          @revisions ||= @options.revisions.map do |rev|
            next unless rev
            git(work_dir, "rev-parse #{rev}").strip
          end
        end

        def work_dir
          Dir.pwd
        end
      end
    end
  end
end
