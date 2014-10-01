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
                  names = []
                  signature.each do |tuple|
                    if name = name_from_tuple(*tuple)
                      names << name
                    end
                  end
                  names
                end

                def name_from_tuple(a, _, b)
                  if b.nil?
                    a
                  else
                    if a == "\\\\"
                      b.first.first
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
