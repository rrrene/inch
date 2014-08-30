require 'forwardable'

module Inch
  module Language
    module Elixir
      # This is the base class for code object proxies.
      # Code object proxies are via an attributes Hash and provide all methods
      # necessary for the evaluation of its documentation.
      #
      # @abstract
      module CodeObject
        class Base < Inch::CodeObject::Proxy
          def language
            :elixir
          end

          # @return [Boolean] if the current object is an alias for something
          #   else
          def alias?
            !aliased_object.nil?
          end

          # @return [CodeObject::Proxy] the object the current object is an
          #   alias of
          def aliased_object
            object_lookup.find(self[:aliased_object_fullname])
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
            self[:core?]
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
            !self[:aliases_fullnames].empty?
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

          def original_docstring
            self[:original_docstring]
          end

          # @return [Boolean] +true+ if the object was tagged not to be
          #   documented
          def nodoc?
            self[:nodoc?]
          end

          # @return [CodeObject::Proxy,nil] the parent of the current object
          #   or +nil+
          def parent
            object_lookup.find(self[:parent_fullname])
          end

          def private?
            self[:private?]
          end

          # @return [Boolean]
          #   +true+ if the object or its parent is tagged as @private
          def tagged_as_private?
            self[:tagged_as_private?]
          end

          # @return [Boolean]
          #   +true+ if the object or its parent is tagged as part of an
          #   internal api
          def tagged_as_internal_api?
            self[:tagged_as_internal_api?]
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

          def type
            self.class.to_s.gsub(/Object$/, '')
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
        end
      end
    end
  end
end
