require 'forwardable'

module Inch
  module CodeObject
    module Proxy
      class Base
        extend Forwardable

        # the actual (YARD) code object
        attr_accessor :object

        # convenient shortcuts to (YARD) code object
        def_delegators :object, :type, :path, :files, :namespace, :source, :source_type, :signature, :group, :dynamic, :visibility, :docstring

        # convenient shortcuts to evalution object
        def_delegators :evaluation, :score, :roles

        def initialize(object)
          self.object = object
        end

        # @return [Fixnum] the depth of the object in terms of namespace
        def depth(i = 0)
          if object.parent
            Proxy.for(object.parent).depth(i+1)
          else
            i
          end
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
      end
    end
  end
end
