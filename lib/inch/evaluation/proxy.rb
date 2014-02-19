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

require_relative 'proxy/base'
require_relative 'proxy/namespace_object'
require_relative 'proxy/class_object'
require_relative 'proxy/constant_object'
require_relative 'proxy/method_object'
require_relative 'proxy/module_object'
