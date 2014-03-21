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

          parse_codebases

          Output::Diff.new(@options, @compare)
        end

        private

        def parse_codebases
          before_rev = revisions[0]
          after_rev  = revisions[1]
          @codebase_old = codebase_for(before_rev)
          @codebase_new = if after_rev.nil?
              Codebase.parse(work_dir)
            else
              codebase_for(after_rev)
            end
          @compare = API::Compare::Codebases.new(@codebase_old, @codebase_new)
        end

        def codebase_for(revision)
          if cached = codebase_from_cache(revision)
            cached
          else
            codebase = codebase_from_copy(work_dir, revision)
            filename = Codebase::Serializer.filename(revision)
            Codebase::Serializer.save(codebase, filename)
            codebase
          end
        end

        def codebase_from_cache(revision)
          filename = Codebase::Serializer.filename(revision)
          if File.exist?(filename)
            Codebase::Serializer.load(filename)
          end
        end

        def codebase_from_copy(original_dir, revision)
          codebase = nil
          Dir.mktmpdir do |tmp_dir|
            new_dir = copy_work_dir(original_dir, tmp_dir)
            git_reset(new_dir, revision)
            codebase = Codebase.parse(new_dir)
          end
          codebase
        end

        def copy_work_dir(original_dir, tmp_dir)
          git tmp_dir, "clone #{original_dir}"
          File.join(tmp_dir, File.basename(original_dir))
        end

        def git_reset(dir, revision = nil)
          git dir, "reset --hard #{revision}"
        end

        def git(dir, command)
          old_pwd = Dir.pwd
          Dir.chdir dir
          out = `git #{command}`
          Dir.chdir old_pwd
          out
        end

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
