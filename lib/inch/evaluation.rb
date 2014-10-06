module Inch
  # The Evaluation module concerns itself with the evaluation of code objects
  # with regard to their inline code documentation
  module Evaluation
    def self.for(language, code_object)
      class_for(language, code_object).new(code_object)
    end

    private

    def self.class_for(_language, code_object)
      class_name = code_object.class.to_s.split('::').last
      language_namespace = Evaluation::Ruby
      language_namespace.const_get(class_name)
    end
  end
end

require 'inch/utils/read_write_methods'

require 'inch/evaluation/file'
require 'inch/evaluation/grade'
require 'inch/evaluation/grade_list'
require 'inch/evaluation/priority_range'

require 'inch/evaluation/proxy'
require 'inch/evaluation/role'
