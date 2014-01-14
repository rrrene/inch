require 'forwardable'

module Inch
  module CodeObject
    module Proxy
      class Base
        extend Forwardable

        attr_accessor :object

        def_delegators :object, :type, :path, :files, :namespace, :source, :source_type, :signature, :group, :dynamic, :visibility, :docstring

        def initialize(object)
          self.object = object
        end

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
          @evaluation ||= CodeObject::Evaluation.for(self)
        end

        def has_code_example?
          !object.tags(:example).empty? ||
            docstring.contains_code_example?
        end

        def has_doc?
          !docstring.empty?
        end

        def namespace?
          false
        end

        def method?
          false
        end

        # Returns +true+ if the object has no documentation whatsoever.
        # @return [Boolean]
        def undocumented?
          docstring.empty? && object.tags.empty?
        end
      end
    end
  end
end
