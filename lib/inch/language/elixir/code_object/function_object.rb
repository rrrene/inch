require 'inch/language/elixir/code_object/function_parameter_object'

module Inch
  module Language
    module Elixir
      module CodeObject
        # Proxy class for functions
        class FunctionObject < Base
          def bang_name?
            self[:bang_name?]
          end

          def getter?
            self[:getter?]
          end

          def has_parameters?
            !parameters.empty?
          end

          MANY_PARAMETERS_THRESHOLD = 3
          def has_many_parameters?
            parameters.size > MANY_PARAMETERS_THRESHOLD
          end

          def has_many_lines?
            false
          end

          def parameter(name)
            parameters.find { |p| p.name == name.to_s }
          end

          def parameters
            @parameters ||= self[:parameters].map do |param_attr|
              FunctionParameterObject.new(param_attr)
            end
          end

          def overridden?
            self[:overridden?]
          end

          def overridden_method
            @overridden_method ||=
              object_lookup.find(self[:overridden_method_fullname])
          end

          def return_mentioned?
            self[:return_mentioned?]
          end

          def return_described?
            self[:return_described?]
          end

          def return_typed?
            self[:return_typed?]
          end

          def setter?
            self[:setter?]
          end

          def source
            self[:source?]
          end

          def questioning_name?
            self[:questioning_name?]
          end
        end
      end
    end
  end
end
