module Inch
  module CodeObject
    module Evaluation
      def self.for(code_object)
        class_for(code_object).new(code_object)
      end

      private
      def self.class_for(code_object)
        class_name = code_object.class.to_s.split('::').last
        eval(class_name)
      rescue
        Base
      end
    end
  end
end

require_relative 'evaluation/base'
require_relative 'evaluation/namespace_object'
require_relative 'evaluation/class_object'
require_relative 'evaluation/constant_object'
require_relative 'evaluation/method_object'
require_relative 'evaluation/module_object'

require_relative 'evaluation/score/base'
require_relative 'evaluation/score/object_has_doc'
require_relative 'evaluation/score/method_has_no_parameters'
require_relative 'evaluation/score/method_parameter_is_mentioned'
require_relative 'evaluation/score/method_parameter_is_typed'
require_relative 'evaluation/score/method_has_return_type'
