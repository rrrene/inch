require 'forwardable'

module Inch
  module CodeObjectProxy
    class Base
      extend Forwardable

      attr_accessor :object

      def_delegators :object, :type, :path, :files, :namespace, :source, :source_type, :signature, :group, :dynamic, :visibility, :docstring

      def initialize(object)
        self.object = object
      end

      def has_doc?
        !!docstring
      end
    end
  end
end
