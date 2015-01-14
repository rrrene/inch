require 'inch/language/javascript/provider/jsdoc/object/function_parameter_object'

module Inch
  module Language
    module JavaScript
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
