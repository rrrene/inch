module Inch
  module Language
    module Elixir
      module Provider
        module Reader
          module Object
            # Proxy class for modules
            class ModuleObject < Base
              def original_docstring
                @hash['moduledoc']
              end

              HIDDEN_TYPES = %w(impl)
              def nodoc?
                @hash['moduledoc'] == false ||
                  HIDDEN_TYPES.include?(@hash['type'])
              end

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
