require 'pry'
require_relative 'options/diff'
require_relative 'output/diff'

module Inch
  module CLI
    module Command
      class Diff < Base
        register_command_as :diff

        def description
          'Shows a diff'
        end

        def usage
          'Usage: inch diff [options]'
        end

        def run(*args)
          @options.parse(args)
          @options.verify

          before_rev, after_rev = revisions[0], revisions[1]
          diff = API::Diff.new(work_dir, before_rev, after_rev)

          Output::Diff.new(@options, diff.comparer)
        end

        private

        def git(dir, command)
          old_pwd = Dir.pwd
          Dir.chdir dir
          out = `git #{command}`
          Dir.chdir old_pwd
          out
        end

        # @return [Array<String>] the revisions passed in the command_line
        def revisions
          @revisions ||= @options.revisions.map do |rev|
            if rev
              git(work_dir, "rev-parse #{rev}").strip
            end
          end
        end

        def work_dir
          Dir.pwd
        end
      end
    end
  end
end
