module Inch
  # The Evaluation module concerns itself with the evaluation of code objects
  # with regard to their inline code documentation
  module Evaluation
    def self.for(language, code_object)
      class_for(language, code_object).new(code_object)
    end

    private

    def self.class_for(language, code_object)
      class_name = code_object.class.to_s.split("::").last
      language_namespace = Evaluation::Ruby
      language_namespace.const_get(class_name)
    end
  end
end

require "inch/utils/read_write_methods"

require "inch/evaluation/file"
require "inch/evaluation/grade"
require "inch/evaluation/grade_list"
require "inch/evaluation/priority_range"

require "inch/evaluation/proxy"
require "inch/evaluation/role"

require "inch/evaluation/ruby/base"
require "inch/evaluation/ruby/namespace_object"
require "inch/evaluation/ruby/class_object"
require "inch/evaluation/ruby/class_variable_object"
require "inch/evaluation/ruby/constant_object"
require "inch/evaluation/ruby/method_object"
require "inch/evaluation/ruby/module_object"

require "inch/evaluation/ruby/roles/base"
require "inch/evaluation/ruby/roles/missing"
require "inch/evaluation/ruby/roles/object"
require "inch/evaluation/ruby/roles/method"
require "inch/evaluation/ruby/roles/method_parameter"
require "inch/evaluation/ruby/roles/namespace"
require "inch/evaluation/ruby/roles/constant"
require "inch/evaluation/ruby/roles/class_variable"
