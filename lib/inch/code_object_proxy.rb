module Inch
  module CodeObjectProxy
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

require_relative 'code_object_proxy/base'
require_relative 'code_object_proxy/class_object'
require_relative 'code_object_proxy/constant_object'
require_relative 'code_object_proxy/method_object'
require_relative 'code_object_proxy/module_object'
