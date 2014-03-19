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

require_relative 'proxy/base'
require_relative 'proxy/namespace_object'
require_relative 'proxy/class_object'
require_relative 'proxy/constant_object'
require_relative 'proxy/method_object'
require_relative 'proxy/method_parameter_object'
require_relative 'proxy/module_object'
