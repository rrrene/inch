module Inch
  module Language
    module Nodejs
      module Provider
        module JSDoc
          module Object
            # Proxy class for modules
            class ModuleObject < Base
              def fullname
                @hash['id']
              end

              def namespace?
                true
              end
            end
          end
        end
      end
    end
  end
end
