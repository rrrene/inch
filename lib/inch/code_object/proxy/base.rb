require 'forwardable'

module Inch
  module CodeObject
    module Proxy
      # @abstract
      class Base
        extend Forwardable

        # @return [Symbol]
        #   when objects are assigned to GradeLists, this grade is set to
        #   enable easier querying for objects of a certain grade
        attr_writer :grade

        # @return [#find]
        #  an object that responds to #find to look up objects by their
        #  full name
        attr_accessor :object_lookup

        # convenient shortcuts to evalution object
        def_delegators :evaluation, :score, :roles, :priority

        def initialize(attributes)
          @attributes = attributes
        end

        # Returns the attribute for the given +key+
        #
        # @param key [Symbol]
        def [](key)
          @attributes[key]
        end

        # @return [Evaluation::Base]
        def evaluation
          @evaluation ||= Evaluation::Proxy.for(self)
        end

        # @return [Symbol]
        def grade
          @grade ||= Evaluation.new_grade_lists.detect { |range|
                range.scores.include?(score)
              }.grade
        end

        # @return [Boolean] +true+ if the object has an @api tag
        def api_tag?
          self[:api_tag?]
        end

        # @return [Array] the children of the current object
        def children
          @children ||= self[:children_fullnames].map do |fullname|
            object_lookup.find(fullname)
          end
        end

        # @return [Boolean] +true+ if the object represents a constant
        def constant?
          self[:constant?]
        end

        def core?
          self[:api_tag?]
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
        # @return [Fixnum] the depth of the object in terms of namespace
        def depth
          self[:depth]
        end

        # @return [Docstring]
        def docstring
          self[:docstring]
        end

        def files
          self[:files]
        end

        # Returns the name of the file where the object is declared first
        # @return [String] a filename
        def filename
          # just checking the first file (which is the file where an object
          # is first declared)
          files.first
        end

        # @return [String] the name of an object, e.g.
        #   "Docstring"
        def name
          self[:name]
        end

        # @return [String] the fully qualified name of an object, e.g.
        #   "Inch::CodeObject::Provider::YARD::Docstring"
        def fullname
          self[:fullname]
        end

        def has_alias?
          self[:has_alias?]
        end

        def has_children?
          self[:has_children?]
        end

        def has_code_example?
          self[:has_code_example?]
        end

        def has_doc?
          self[:has_doc?]
        end

        def has_multiple_code_examples?
          self[:has_multiple_code_examples?]
        end

        def has_unconsidered_tags?
          self[:has_unconsidered_tags?]
        end

        def in_root?
          self[:in_root?]
        end

        # @return [Boolean] +true+ if the object represents a method
        def method?
          self[:method?]
        end

        # @return [Boolean] +true+ if the object represents a namespace
        def namespace?
          self[:namespace?]
        end

        # @return [Boolean] +true+ if the object was tagged not to be documented
        def nodoc?
          self[:nodoc?]
        end

        # @return [Array,nil] the parent of the current object or +nil+
        def parent
          object_lookup.find( self[:parent_fullname] )
        end

        def private?
          self[:private?]
        end

        # @return [Boolean]
        #   +true+ if the object or its parent is tagged as @private
        def private_tag?
          self[:private_tag?]
        end

        def private_api_tag?
          self[:private_api_tag?]
        end

        def protected?
          self[:protected?]
        end

        def public?
          self[:public?]
        end

        def source
          self[:source]
        end

        # @return [Boolean] +true+ if the object has no documentation at all
        def undocumented?
          self[:undocumented?]
        end

        # @return [Fixnum] the amount of tags not considered for this object
        def unconsidered_tag_count
          self[:unconsidered_tag_count]
        end

        def visibility
          self[:visibility]
        end

        def inspect
          "#<#{self.class.to_s}: #{fullname}>"
        end
      end
    end
  end
end
