require 'English'

module Inch
  module Language
    module Ruby
      module Provider
        module YARD
          module NodocHelper
            # Returns true if the code object is somehow marked not to be
            # documented.
            #
            # @note Doesnot recognize ":startdoc:" and ":stopdoc:"
            #
            def nodoc?
              tagged_as_private? || nodoc_comment?
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

            # Returns all lines in all files declaring the object
            #
            # @example
            #   declarations # => ["class Base # :nodoc:", "class Foo < Base"]
            #
            # @return [Array<String>]
            def declarations
              @declarations ||= files.map do |f|
                get_line_no(f.filename, f.line_no)
              end
            end

            # Returns a +line_number+ from a file
            #
            # @param filename [String]
            # @param line_number [Fixnum]
            # @return [String]
            def get_line_no(filename, line_number)
              f = File.open(filename)
              line_number.times { f.gets }
              result = $LAST_READ_LINE
              f.close
              result.encode('UTF-8', 'binary',
                            invalid: :replace, undef: :replace, replace: '')
            end
          end
        end
      end
    end
  end
end
