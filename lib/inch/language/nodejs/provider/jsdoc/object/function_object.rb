require 'inch/language/nodejs/provider/jsdoc/object/function_parameter_object'

module Inch
  module Language
    module Nodejs
      module Provider
        module JSDoc
          module Object
            # Proxy class for functions
            class FunctionObject < Base
              def method?
                true
              end
            end
          end
        end
      end
    end
  end
end
