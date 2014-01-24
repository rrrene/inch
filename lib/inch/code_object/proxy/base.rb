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
        attr_writer :grade

        # Tags considered by wrapper methods like {#has_code_example?}
        CONSIDERED_YARD_TAGS = %w(example param private return)

        # convenient shortcuts to (YARD) code object
        def_delegators :object, :type, :path, :name, :namespace, :source, :source_type, :signature, :group, :dynamic, :visibility, :docstring

        # convenient shortcuts to evalution object
        def_delegators :evaluation, :score, :roles, :priority

        def initialize(object)
          self.object = object
        end

        # To be overridden
        # @see Proxy::NamespaceObject
        # @return [Array,nil] the children of the current object or +nil+
        def children
          nil
        end

        def docstring
          @docstring ||= Docstring.new(object.docstring)
        end

        def evaluation
          @evaluation ||= Evaluation.for(self)
        end

        def grade
          @grade ||= Evaluation.new_score_ranges.detect { |range|
                range.range.include?(score)
              }.grade
        end

        def has_alias?
          !object.aliases.empty?
        end

        def has_code_example?
          !object.tags(:example).empty? ||
            docstring.contains_code_example?
        end

        def has_doc?
          !docstring.empty?
        end

        def has_multiple_code_examples?
          if object.tags(:example).size > 1 || docstring.code_examples.size > 1
            true
          else
            if tag = object.tag(:example)
              multi_code_examples?(tag.text)
            elsif text = docstring.code_examples.first
              multi_code_examples?(text)
            else
              false
            end
          end
        end

        def has_unconsidered_tags?
          !unconsidered_tags.empty?
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

        # @return [Boolean] +true+ if the object represents a method
        def method?
          false
        end

        # @return [Boolean] +true+ if the object represents a namespace
        def namespace?
          false
        end

        # @return [Array,nil] the parent of the current object or +nil+
        def parent
          Proxy.for(object.parent) if object.parent
        end

        def private?
          visibility == :private
        end

        def private_tag?
          !!object.tag(:private)
        end

        def protected?
          visibility == :protected
        end

        def public?
          visibility == :public
        end

        # @return [Boolean] +true+ if the object has no documentation at all
        def undocumented?
          docstring.empty? && object.tags.empty?
        end

        # @return [Array]
        #   YARD tags that are not already covered by other wrapper methods
        def unconsidered_tags
          @unconsidered_tags ||= object.tags.reject do |tag|
              CONSIDERED_YARD_TAGS.include?(tag.name)
            end
        end

        def inspect
          "#<#{self.class.to_s}: #{path}>"
        end

        private

        def multi_code_examples?(text)
          text =~ /\b#{Regexp.escape(name)}[^_0-9\!\?]/
        end
      end
    end
  end
end
