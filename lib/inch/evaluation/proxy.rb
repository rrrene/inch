module Inch
  # The Evaluation module concerns itself with the evaluation of code objects
  # with regard to their inline code documentation
  module Evaluation
    module Proxy
      def self.for(code_object)
        class_for(code_object).new(code_object)
      end

      private

      def self.class_for(code_object)
        class_name = code_object.class.to_s.split('::').last
        const_get(class_name)
      end
    end
  end
end

require 'inch/evaluation/proxy/base'
require 'inch/evaluation/proxy/namespace_object'
require 'inch/evaluation/proxy/class_object'
require 'inch/evaluation/proxy/constant_object'
require 'inch/evaluation/proxy/method_object'
require 'inch/evaluation/proxy/module_object'
