module Inch
  module CodeObject
    module Proxy
      class << self
        def for(code_object)
          @cache ||= {}
          if proxy_object = @cache[cache_key(code_object)]
            proxy_object
          else
            @cache[cache_key(code_object)] = class_for(code_object).new(code_object)
          end
        end

        private

        def class_for(code_object)
          class_name = code_object.class.to_s.split('::').last
          eval("::Inch::CodeObject::Proxy::#{class_name}")
        rescue
          Base
        end

        def cache_key(o)
          o.path
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
