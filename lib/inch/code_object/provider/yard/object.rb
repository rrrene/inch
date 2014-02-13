module Inch
  module CodeObject
    module Provider
      # CodeObject::Proxy object represent code objects in the analaysed
      # codebase.
      #
      module YARD
        module Object
          class << self
            # Returns a Proxy object for the given +code_object+
            #
            # @param code_object [Provider::YARD::Object]
            # @return [CodeObject::Proxy::Base]
            def for(code_object)
              @cache ||= {}
              if proxy_object = @cache[cache_key(code_object)]
                proxy_object
              else
                @cache[cache_key(code_object)] = class_for(code_object).new(code_object)
              end
            end

            private

            # Returns a Proxy class for the given +code_object+
            #
            # @param code_object [YARD::CodeObject]
            # @return [Class]
            def class_for(code_object)
              class_name = code_object.class.to_s.split('::').last
              eval("::Inch::CodeObject::Proxy::Provider::YARD::Object::#{class_name}")
            rescue
              Base
            end

            # Returns a cache key for the given +code_object+
            #
            # @return [String]
            def cache_key(code_object)
              code_object.path
            end
          end
        end
      end
    end
  end
end

require_relative 'object/base'
require_relative 'object/namespace_object'
require_relative 'object/class_object'
require_relative 'object/constant_object'
require_relative 'object/method_object'
require_relative 'object/method_parameter_object'
require_relative 'object/module_object'
