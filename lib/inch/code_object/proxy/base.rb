require 'forwardable'

module Inch
  module CodeObject
    module Proxy
      class Base
        extend Forwardable
        include NodocHelper

        # the actual (YARD) code object
        attr_accessor :object

        # @return [Symbol]
        #   when objects are assigned to ScoreRanges, this grade is set to
        #   enable easier querying for objects of a certain grade
        attr_accessor :grade

        # convenient shortcuts to (YARD) code object
        def_delegators :object, :type, :path, :namespace, :source, :source_type, :signature, :group, :dynamic, :visibility, :docstring

        # convenient shortcuts to evalution object
        def_delegators :evaluation, :score, :roles, :priority

        def initialize(object)
          self.object = object
        end

        def has_alias?
          !object.aliases.empty?
        end

        def in_root?
          depth == 1
        end

        # The depth of the following is 4:
        #
        #   Foo::Bar::Baz#initialize
        #    ^    ^    ^      ^
        #    1 << 2 << 3  <<  4
        #
        # +depth+ answers the question "how many layers of code objects are
        # above this one?"
        #
        # @note top-level counts, that's why Foo has depth 1!
        #
        # @param i [Fixnum] a counter for recursive method calls
        # @return [Fixnum] the depth of the object in terms of namespace
        def depth(i = 0)
          if parent
            parent.depth(i+1)
          else
            i
          end
        end

        # In the following example, the height of +Foo+ is 3
        # (the height of the top-level is 4):
        #
        #   Foo::Bar::Baz#initialize
        #    ^    ^    ^      ^
        #    0 >> 1 >> 2  >>  3
        #
        # +height+ answers the question "how many layers of code objects are
        # underneath this one?"
        #
        # @param i [Fixnum] a counter for recursive method calls
        # @return [Fixnum] the height of the object in terms of namespace
        def height(i = 0)
          if children && !children.empty?
            children.map do |child|
              child.height(i+1)
            end.max
          else
            i
          end
        end

        # @see Proxy::NamespaceObject
        # @return [Array,nil] the children of the current object or +nil+
        def children
          nil
        end

        # @return [Array,nil] the parent of the current object or +nil+
        def parent
          Proxy.for(object.parent) if object.parent
        end

        def docstring
          @docstring ||= Docstring.new(object.docstring)
        end

        def evaluation
          @evaluation ||= Evaluation.for(self)
        end

        def has_code_example?
          !object.tags(:example).empty? ||
            docstring.contains_code_example?
        end

        def has_doc?
          !docstring.empty?
        end

        # @return [Boolean] +true+ if the object represents a namespace
        def namespace?
          false
        end

        # @return [Boolean] +true+ if the object represents a method
        def method?
          false
        end

        # @return [Boolean] +true+ if the object has no documentation at all
        def undocumented?
          docstring.empty? && object.tags.empty?
        end

        def inspect
          "#<#{self.class.to_s}: #{path}>"
        end
      end
    end
  end
end
