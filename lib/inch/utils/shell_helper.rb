module Inch
  module Utils
    module ShellHelper
      def git(dir, command)
        old_pwd = Dir.pwd
        Dir.chdir dir
        out = `git #{command}`
        Dir.chdir old_pwd
        out
      end
    end
  end
end
