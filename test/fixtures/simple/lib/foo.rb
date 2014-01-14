# The module 'Foo' has a doc string (this), but the class
# 'Foo::Bar' does not.
module Foo
  class Bar
    def method_without_doc
    end

    # Provides an example of a missing described parameter.
    #
    # @param param1 [String]
    # @param param2 [String, nil]
    # @return [void]
    def method_with_missing_param_doc(param1, param2, param3)
    end

    # Provides an example of a wrongly described parameter.
    #
    # @param param1 [String]
    # @param param4 [String, nil]
    # @return [void]
    def method_with_wrong_doc(param1, param2, param3)
    end

    # Provides an example of a fully described method.
    #
    # @param p1 [String] mandatory param
    # @param p2 [String, nil] optionally param
    # @return [void]
    def method_with_full_doc(p1, p2 = nil)
    end

    # @param p1 [String] mandatory param
    # @param p2 [String, nil] optionally param
    # @return [void]
    def method_without_docstring(p1, p2 = nil)
    end

    # @return [void]
    def method_without_params_or_docstring
    end

    # Provides an example of a method without parameters
    # missing the return type.
    #
    def method_without_params_or_return_type
    end

    # An example of a method using RDoc rather than YARD.
    #
    # == Parameters:
    # param1::
    #   A Symbol declaring some markup language like `:md` or `:html`.
    #
    # == Returns:
    # A string in the specified format.
    #
    def method_with_rdoc_doc(param1 = :html)
    end

    # Another example of a method using RDoc rather than YARD.
    #
    # Params:
    # +param1+:: param1 line string to be executed by the system
    # +param2+:: +Proc+ object that takes a pipe object as first and only param (may be nil)
    # +param3+:: +Proc+ object that takes a pipe object as first and only param (may be nil)
    def method_with_other_rdoc_doc(param1, param2, param3)
    end

    # An example of a method that takes a parameter (+param1+)
    # and does nothing. But the previous sentence mentions said
    # parameter.
    #
    def method_with_unstructured_doc(param1)
    end

    # Just because format_html is mentioned here, does not mean
    # the first parameter is mentioned.
    #
    def method_with_unstructured_doc_missing_params(format)
    end
  end

  class Baz < Bar
    def method_with_missing_param_doc(param1, param2, param3)
    end
  end

  # Some documentation.
  class Qux
  end
end
