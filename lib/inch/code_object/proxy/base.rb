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

        # convenient shortcuts to evalution object
        def_delegators :evaluation, :score, :roles, :priority

        def initialize(attributes)
          @attributes = attributes
        end

        def [](key)
          @attributes[key]
        end

        # @return [Evaluation::Base]
        def evaluation
          @evaluation ||= Evaluation.for(self)
        end

        # @return [Symbol]
        def grade
          @grade ||= Evaluation.new_grade_lists.detect { |range|
                range.scores.include?(score)
              }.grade
        end

        def api_tag?
          self[:api_tag?]
        end

        # To be overridden
        # @see Proxy::NamespaceObject
        # @return [Array,nil] the children of the current object or +nil+
        def children
        end

        # @return [Boolean] +true+ if the object represents a constant
        def constant?
          self[:constant?]
        end

        def core?
          self[:api_tag?]
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
          files.size > 0 ? files[0][0] : nil
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

        # @return [Array,nil] the parent of the current object or +nil+
        def parent

        end

        def private?
          self[:private?]
        end

        # @return [Boolean]
        #   +true+ if the object or its parent is tagged as @private
        def private_tag?
          self[:private_tag?]
        end

        def private_tag
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

        # @return [Boolean] +true+ if the object has no documentation at all
        def undocumented?
          self[:undocumented?]
        end

        # @return [Array]
        #   YARD tags that are not already covered by other wrapper methods
        def unconsidered_tags
          self[:unconsidered_tags?]
        end

        def inspect
          "#<#{self.class.to_s}: #{path}>"
        end
      end
    end
  end
end
