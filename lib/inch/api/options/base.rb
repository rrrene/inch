module Inch
  module API
    module Options
      class Base
        class << self
          # Creates an attribute with an optional default value
          #
          # @param name [Symbol] the name of the attribute
          # @param default [nil] the default value of the attribute
          # @return [void]
          def attribute(name, default = nil)
            define_method(name) do
              instance_variable_get("@#{name}") || default
            end
            @attributes ||= {}
            @attributes[to_s] ||= []
            @attributes[to_s] << name
          end

          def attribute_names
            @attributes ||= {}
            @attributes[to_s] ||= []
          end
        end

        def initialize(options_or_hash)
          self.class.attribute_names.each do |name|
            read options_or_hash, name
          end
        end

        protected

        def read(options_or_hash, name)
          value = if options_or_hash.is_a?(Hash)
                    options_or_hash[name]
                  else
                    options_or_hash.send(name)
                  end
          instance_variable_set("@#{name}", value)
        end
      end
    end
  end
end
