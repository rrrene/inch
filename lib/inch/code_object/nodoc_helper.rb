module Inch
  module CodeObject
    module NodocHelper

      # Returns true if the code object is somehow marked not to be
      # documented.
      #
      # @note Doesnot recognize ":startdoc:" and ":stopdoc:"
      #
      def nodoc?
        object.tag(:private) || nodoc_comment?
      end

      NO_DOC_REGEX = /#\s*\:nodoc\:/
      NO_DOC_ALL_REGEX = /#\s*\:nodoc\:\s*all/
      DOC_REGEX = /#\s*\:doc\:/

      def nodoc_comment?
        explicit_nodoc_comment? || implicit_nodoc_comment?
      end

      def explicit_nodoc_comment?
        declarations.any? { |str| str =~ NO_DOC_REGEX }
      end

      def explicit_nodoc_all_comment?
        declarations.any? { |str| str =~ NO_DOC_ALL_REGEX }
      end

      def explicit_doc_comment?
        declarations.any? { |str| str =~ DOC_REGEX }
      end

      def implicit_nodoc_all_comment?
        if parent
          parent.explicit_nodoc_all_comment? ||
            parent.implicit_nodoc_all_comment?
        end
      end

      def implicit_nodoc_comment?
        return false if explicit_doc_comment?

        if parent
          return false if parent.explicit_doc_comment?

          if namespace?
            if parent.explicit_nodoc_all_comment?
              return true
            else
              return parent.implicit_nodoc_all_comment?
            end
          else
            if parent.explicit_nodoc_comment?
              return true
            else
              return parent.implicit_nodoc_all_comment?
            end
          end
        end
      end

      def declarations
        @declarations ||= files.map do |(filename, line_no)|
          get_line_no(filename, line_no)
        end
      end

      def files
        object.files
      rescue YARD::CodeObjects::ProxyMethodError
        []
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
