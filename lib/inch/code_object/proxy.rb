module Inch
  module CodeObject
    module Proxy
      def self.for(code_object)
        class_for(code_object).new(code_object)
      end

      private
      def self.class_for(code_object)
        class_name = code_object.class.to_s.split('::').last
        eval(class_name)
      rescue
        Base
      end
    end
  end
end

require_relative 'proxy/base'
require_relative 'proxy/namespace_object'
require_relative 'proxy/class_object'
require_relative 'proxy/constant_object'
require_relative 'proxy/method_object'
require_relative 'proxy/module_object'
