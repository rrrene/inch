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
  end
end