require 'inch/language/elixir/provider/reader/object/function_parameter_object'

module Inch
  module Language
    module Elixir
      module Provider
        module Reader
          module Object
            # Proxy class for functions
            class FunctionObject < Base
              def name
                @hash['id']
              end

              def fullname
                @hash['module_id'] + '.' + @hash['id']
              end

              def method?
                true
              end

              def parameters
                names = FunctionSignature.new(name, @hash['signature']).parameter_names
                names.map do |name|
                  FunctionParameterObject.new(self, name)
                end
              end

              private

              class FunctionSignature < Struct.new(:fun_name, :signature)
                def parameter_names
                  base_name = fun_name.split('/').first
                  signature.gsub(/^(#{base_name}\()/, '').gsub(/(\))$/, '')
                    .gsub( /\([^\)]+\)/, '' )
                    .split(',')
                    .map do |param|
                      name = param.split("\\\\").first
                      name && name.strip
                    end.compact
                end
              end
            end
          end
        end
      end
    end
  end
end
