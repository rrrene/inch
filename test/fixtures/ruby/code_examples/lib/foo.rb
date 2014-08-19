# The module 'Foo' has a doc string (this), but the class
# 'Foo::Bar' does not.
module Foo
  class Bar
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
