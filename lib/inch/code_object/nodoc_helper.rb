module Inch
  module CodeObject
    module NodocHelper

      # Returns true if the code object is somehow marked not to be 
      # documented.
      #
      # @todo Doesnot recognize ":doc:"
      # @todo Doesnot recognize ":nodoc: all"
      # @todo Doesnot recognize ":startdoc:" and ":stopdoc:"
      #
      def nodoc?
        object.tag(:private) || nodoc_comment?
      end

      NO_DOC_REGEX = /#\s+\:nodoc\:/

      def nodoc_comment?
        explicit_nodoc_comment? || implicit_nodoc_comment?
      end

      def explicit_nodoc_comment?
        declarations.any? { |str| str =~ NO_DOC_REGEX }
      end

      def implicit_nodoc_comment?
        if !namespace? && parent
          parent.nodoc_comment?
        end
      end

      def declarations
        @declarations ||= object.files.map do |(filename, line_no)|
          get_line_no(filename, line_no)
        end
      end

      def get_line_no(filename, n)
        f = File.open(filename)
        n.times{f.gets}
        result = $_
        f.close
        result
      end
    end
  end
end
