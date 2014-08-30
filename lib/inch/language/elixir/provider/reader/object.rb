require 'inch/language/elixir/provider/reader/object/base'
require 'inch/language/elixir/provider/reader/object/function_object'
require 'inch/language/elixir/provider/reader/object/module_object'
require 'inch/language/elixir/provider/reader/object/type_object'

module Inch
  module Language
    module Elixir
      module Provider
        module Reader
          # CodeObject::Provider::JSDoc::Object object represent code objects.
          #
          module Object
            class << self
              def clear_cache
                @cache = {}
              end

              # Returns a Proxy object for the given +json_object+
              #
              # @param json_object [Hash]
              # @return [Provider::JSDoc::Object]
              def for(json_object)
                @cache ||= {}
                if (proxy_object = @cache[cache_key(json_object)])
                  proxy_object
                else
                  @cache[cache_key(json_object)] =
                    class_for(json_object).new(json_object)
                end
              end

              private

              # Returns a Proxy class for the given +json_object+
              #
              # @param json_object [Hash]
              # @return [Class]
              def class_for(json_object)
                class_name = json_object['object_type']
                Reader::Object.const_get(class_name)
              rescue NameError
                Reader::Object::Base
              end

              # Returns a cache key for the given +json_object+
              #
              # @param json_object [Hash]
              # @return [String]
              def cache_key(json_object)
                [
                  json_object['id'],
                  json_object['module_id'],
                  json_object['signature']
                ].map(&:to_s).join('.')
              end
            end
          end
        end
      end
    end
  end
end
