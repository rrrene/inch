module Inch
  module Language
    module Ruby
      module Provider
        module YARD
          # CodeObject::Provider::YARD::Object object represent code objects.
          #
          module Object
            class << self
              def clear_cache
                @cache = {}
              end

              # Returns a Proxy object for the given +yard_object+
              #
              # @param yard_object [YARD::CodeObject]
              # @return [Provider::YARD::Object]
              def for(yard_object)
                @cache ||= {}
                if (proxy_object = @cache[cache_key(yard_object)])
                  proxy_object
                else
                  @cache[cache_key(yard_object)] =
                    class_for(yard_object).new(yard_object)
                end
              end

              private

              # Returns a Proxy class for the given +yard_object+
              #
              # @param yard_object [YARD::CodeObject]
              # @return [Class]
              def class_for(yard_object)
                class_name = yard_object.class.to_s.split('::').last
                const_get(class_name)
              rescue NameError
                Base
              end

              # Returns a cache key for the given +yard_object+
              #
              # @param yard_object [YARD::CodeObject]
              # @return [String]
              def cache_key(yard_object)
                yard_object.path
              end
            end
          end
        end
      end
    end
  end
end

require 'inch/language/ruby/provider/yard/object/base'
require 'inch/language/ruby/provider/yard/object/namespace_object'
require 'inch/language/ruby/provider/yard/object/class_object'
require 'inch/language/ruby/provider/yard/object/class_variable_object'
require 'inch/language/ruby/provider/yard/object/constant_object'
require 'inch/language/ruby/provider/yard/object/method_object'
require 'inch/language/ruby/provider/yard/object/method_parameter_object'
require 'inch/language/ruby/provider/yard/object/module_object'
