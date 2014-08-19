module Foo
  class Qux # :nodoc:
    def method_with_implicit_nodoc
    end

    DOCCED_VALUE = 42 # :doc:

    class Quux
      def method_without_nodoc
      end

      PUBLIC_VALUE = :foo
      PRIVATE_VALUE = :bar # :nodoc:

      # @private
      def method_with_private_tag
      end

      def method_with_explicit_nodoc # :nodoc:
      end
    end
  end

  class HiddenClass #:nodoc: all
    def some_value
    end

    class EvenMoreHiddenClass
      def method_with_implicit_nodoc
      end

      class SuddenlyVisibleClass # :doc:
        def method_with_implicit_doc
        end
      end
    end
  end

  # @private
  class HiddenClassViaTag
    # @api private
    def some_value
    end
  end
end
