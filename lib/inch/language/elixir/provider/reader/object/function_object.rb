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
                @hash['module_id'] + "." + @hash['id']
              end

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
