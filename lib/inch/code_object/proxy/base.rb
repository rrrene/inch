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

        def evaluation
          @evaluation ||= CodeObject::Evaluation.for(self)
        end

        def has_doc?
          docstring && !docstring.empty?
        end

        def namespace?
          false
        end

        def method?
          false
        end
      end
    end
  end
end
