require 'inch/language/elixir/provider/reader_v2/object/base'
require 'inch/language/elixir/provider/reader_v2/object/function_object'
require 'inch/language/elixir/provider/reader_v2/object/module_object'
require 'inch/language/elixir/provider/reader_v2/object/type_object'

module Inch
  module Language
    module Elixir
      module Provider
        module ReaderV2
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
                class_name = json_object['type'].capitalize + "Object"

                ReaderV2::Object.const_get(class_name)
              rescue NameError
                ReaderV2::Object::Base
              end

              # Returns a cache key for the given +json_object+
              #
              # @param json_object [Hash]
              # @return [String]
              def cache_key(json_object)
                json_object['name']
              end
            end
          end
        end
      end
    end
  end
end
