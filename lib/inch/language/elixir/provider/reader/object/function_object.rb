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
                names = FunctionSignature.new(@hash['signature']).parameter_names
                names.map do |name|
                  FunctionParameterObject.new(self, name)
                end
              end

              private

              class FunctionSignature < Struct.new(:signature)
                def parameter_names
                  return [] if signature.nil?
                  signature.map do |tuple|
                    name_from_tuple(*tuple)
                  end
                end

                def name_from_tuple(a, _, b)
                  if b.nil? || b == 'Elixir'
                    a
                  else
                    if a == '\\\\'
                      name_from_tuple(*b.first)
                    else
                      warn "[WARN] could not parse FunctionSignature: #{[a, _, b].inspect}"
                    end
                  end
                end
              end

            end
          end
        end
      end
    end
  end
end
