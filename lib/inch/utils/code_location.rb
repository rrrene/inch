module Inch
  module Utils
    # CodeLocation is a utility class to find declarations of objects
    # in files
    class CodeLocation < Struct.new(:base_dir, :relative_path,
                                    :line_no)
      def filename
        File.join(base_dir, relative_path)
      end
    end
  end
end
