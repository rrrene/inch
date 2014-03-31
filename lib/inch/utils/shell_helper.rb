module Inch
  module Utils
    module ShellHelper
      def git(dir, command)
        Dir.chdir(dir) do
          out = sh("git #{command}")
        end
      end

      def sh(command)
        `#{command}`
      end
    end
  end
end
