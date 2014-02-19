module Inch
  # The Evaluation module concerns itself with the evaluation of code objects
  # with regard to their inline code documentation
  module Evaluation
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

require_relative 'utils/read_write_methods'

require_relative 'evaluation/file'
require_relative 'evaluation/grade'
require_relative 'evaluation/grade_list'
require_relative 'evaluation/object_schema'
require_relative 'evaluation/priority_range'

require_relative 'evaluation/role/base'
require_relative 'evaluation/role/missing'
require_relative 'evaluation/role/object'
require_relative 'evaluation/role/method'
require_relative 'evaluation/role/method_parameter'
require_relative 'evaluation/role/namespace'
require_relative 'evaluation/role/constant'

require_relative 'evaluation/proxy'
