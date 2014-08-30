require 'inch/utils/shell_helper'

module Inch
  module CLI
    module Command
      module Options
        class Diff < BaseObject
          include Utils::ShellHelper

          def initialize
            @before_rev = 'HEAD'
            @after_rev  = nil
          end

          def descriptions
            [
              '',
              'Shows changes in documentation between two revisions ' \
                '(defaults to last commit against current)',
              '',
              'Example: ' + '$ inch diff HEAD^..HEAD'.color(:cyan),
              '',
              description_hint_grades,
              description_hint_arrows
            ]
          end

          def set_options(opts)
            diff_options(opts)
            common_options(opts)
          end

          # @return [Array<String>] the revisions to be diffed
          #   nil meaning the current working dir, including untracked files
          #   since these are later parsed via `git rev-parse`, we can support
          #   notations like "HEAD" or "HEAD^^"
          #
          # @example
          #   revisions # => ["HEAD", nil]
          def revisions
            if object_names.empty?
              [@before_rev, @after_rev]
            else
              object_names.first.split('..')
            end
          end

          def since_last_commit?
            revisions == ['HEAD', nil]
          end

          def since_last_push?
            @since_last_push == true
          end

          private

          def diff_options(opts)
            opts.separator ''
            opts.separator 'Diff options:'

            opts.on('--since-last-commit',
                    'Run diff against last commit (default)') do
              @before_rev = 'HEAD'
            end
            opts.on('-p', '--since-last-push',
                    'Run diff against last pushed commit') do
              @before_rev = pushed_rev
              @since_last_push = true
            end
          end

          # @return [String] the reference for the pushed revision
          #
          # @example
          #   pushed_rev # => "origin/master"
          def pushed_rev
            "#{remote}/#{current_branch}"
          end

          def current_branch
            git Dir.pwd, 'rev-parse --abbrev-ref HEAD'
          end

          def remote
            'origin'
          end
        end
      end
    end
  end
end
