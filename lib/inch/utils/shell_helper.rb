module Inch
  module Utils
    module ShellHelper
      def git(dir, command)
        old_pwd = Dir.pwd
        Dir.chdir dir
        out = sh("git #{command}")
        Dir.chdir old_pwd
        out
      end

      def sh(command)
        `#{command}`
      end
    end
  end
end
