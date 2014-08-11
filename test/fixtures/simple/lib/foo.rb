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
      many_lines = true
      if true
        if many_lines
          true
        end
      end
    end

    # @param p1 [String] mandatory param
    # @param p2 [String, nil] optionally param
    # @return [void]
    def method_without_docstring(p1, p2 = nil)
    end

    # @return [String]
    def method_without_params_or_docstring
    end

    # @return [void]
    def method_without_usable_return_value
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

    # Injects text right after the class definition. Since it depends on
    # insert_into_file, it's reversible.
    #
    # ==== Parameters
    # param1<String>:: path of the file to be changed
    # param2<String|Class>:: the class to be manipulated
    #
    # ==== Examples
    #
    #   inject_into_class "app/controllers/application_controller.rb", ApplicationController, "  filter_parameter :password\n"
    #
    #   inject_into_class "app/controllers/application_controller.rb", ApplicationController do
    #     "  filter_parameter :password\n"
    #   end
    def method_with_yet_another_rdoc_doc(param1, param2)
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

    # This is an example:
    #
    #   method_with_code_example() # => some value
    #
    # @param p1 [String] mandatory param
    # @param p2 [String, nil] optionally param
    # @return [void]
    def method_with_code_example(p1, p2 = nil)
    end

    # This is an example:
    #
    # @example
    #   method_with_code_example() # => some value
    #
    # @param p1 [String] mandatory param
    # @param p2 [String, nil] optionally param
    # @return [void]
    def method_with_code_example2(p1, p2 = nil)
    end

    class Baz
      def initialize(param1, param2, param3)
      end

      #
      # Options: noop verbose force
      #
      # Changes owner and group on the named files (in +list+)
      # to the user +user+ and the group +group+ recursively.
      # +user+ and +group+ may be an ID (Integer/String) or
      # a name (String).  If +user+ or +group+ is nil, this
      # method does not change the attribute.
      #
      #   object.method_with_examples 1, 'www', 'www', '/var/www/htdocs'
      #   object.method_with_examples 2, 'cvs', 'cvs', :verbose => true
      #
      def method_with_examples(user, group, list, options = {})
      end

      #
      # Options: noop verbose force
      #
      # Changes owner and group on the named files (in +list+)
      # to the user +user+ and the group +group+ recursively.
      # +user+ and +group+ may be an ID (Integer/String) or
      # a name (String).  If +user+ or +group+ is nil, this
      # method does not change the attribute.
      #
      # @example
      #   object.method_with_tagged_example 1, 'www', 'www', '/var/www/htdocs'
      #   object.method_with_tagged_example 2, 'cvs', 'cvs', :verbose => true
      #
      def method_with_tagged_example(user, group, list, options = {})
      end

      #
      # Options: noop verbose force
      #
      # Changes owner and group on the named files (in +list+)
      # to the user +user+ and the group +group+ recursively.
      # +user+ and +group+ may be an ID (Integer/String) or
      #
      # @example
      #   object.method_with_examples 1, 'www', 'www', '/var/www/htdocs'
      #
      # a name (String).  If +user+ or +group+ is nil, this
      # method does not change the attribute.
      #
      # @example
      #   object.method_with_examples 2, 'cvs', 'cvs', :verbose => true
      #
      def method_with_2tagged_examples(user, group, list, options = {})
      end

      # Changes owner and group on the named files (in +list+)
      #
      #   object.method_with_one_example_other :similar
      #   object.method_with_one_example 'www', 'www', '/var/www/htdocs'
      #   # => 'cvs'
      #
      # No code.
      #
      def method_with_one_example
      end
    end
  end

  class Baz < Bar
    def method_with_missing_param_doc(param1, param2, param3)
    end
  end
end

def top
end
