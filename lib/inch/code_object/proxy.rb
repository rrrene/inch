module Inch
  module CodeObject
    # CodeObject::Proxy object represent code objects in the analaysed
    # codebase.
    #
    module Proxy
      class << self
        # Returns a Proxy object for the given +code_object+
        #
        # @param code_object [YARD::Object::Base]
        # @return [CodeObject::Proxy::Base]
        def for(code_object)
          attributes = Converter.to_hash(code_object)
          proxy_object = class_for(code_object).new(attributes)
        end

        private

        # Returns a Proxy class for the given +code_object+
        #
        # @param code_object [YARD::CodeObject]
        # @return [Class]
        def class_for(code_object)
          class_name = code_object.class.to_s.split('::').last
          const_get(class_name)
        end
      end
    end
  end
end

require 'inch/code_object/proxy/base'
require 'inch/code_object/proxy/namespace_object'
require 'inch/code_object/proxy/class_object'
require 'inch/code_object/proxy/constant_object'
require 'inch/code_object/proxy/method_object'
require 'inch/code_object/proxy/method_parameter_object'
require 'inch/code_object/proxy/module_object'
