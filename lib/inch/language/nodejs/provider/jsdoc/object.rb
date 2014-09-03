require 'inch/language/nodejs/provider/jsdoc/object/base'
require 'inch/language/nodejs/provider/jsdoc/object/function_object'
require 'inch/language/nodejs/provider/jsdoc/object/module_object'
require 'inch/language/nodejs/provider/jsdoc/object/member_object'

module Inch
  module Language
    module Nodejs
      module Provider
        module JSDoc
          # CodeObject::Provider::JSDoc::Object object represent code objects.
          #
          module Object
            class << self
              def clear_cache
                @cache = {}
              end

              # Returns a Proxy object for the given +jsdoc_object+
              #
              # @param jsdoc_object [Hash]
              # @return [Provider::JSDoc::Object]
              def for(jsdoc_object)
                @cache ||= {}
                if (proxy_object = @cache[cache_key(jsdoc_object)])
                  proxy_object
                else
                  @cache[cache_key(jsdoc_object)] =
                    class_for(jsdoc_object).new(jsdoc_object)
                end
              end

              private

              # Returns a Proxy class for the given +json_object+
              #
              # @param json_object [Hash]
              # @return [Class]
              def class_for(json_object)
                class_name = json_object['kind'].capitalize + 'Object'
                JSDoc::Object.const_get(class_name)
              rescue NameError
                JSDoc::Object::Base
              end

              # Returns a cache key for the given +jsdoc_object+
              #
              # @param jsdoc_object [Hash]
              # @return [String]
              def cache_key(jsdoc_object)
                return if jsdoc_object['meta'].nil?
                "#{jsdoc_object['longname']}/" \
                  "#{jsdoc_object['meta']['path']}/" \
                  "#{jsdoc_object['meta']['filename']}:" \
                  "#{jsdoc_object['meta']['lineno']}"
              end
            end
          end
        end
      end
    end
  end
end
