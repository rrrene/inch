module Inch
  module Language
    module Ruby
    end
  end
end

require 'inch/language/ruby/provider/yard'

require 'inch/language/ruby/code_object/base'
require 'inch/language/ruby/code_object/namespace_object'
require 'inch/language/ruby/code_object/class_object'
require 'inch/language/ruby/code_object/class_variable_object'
require 'inch/language/ruby/code_object/constant_object'
require 'inch/language/ruby/code_object/method_object'
require 'inch/language/ruby/code_object/method_parameter_object'
require 'inch/language/ruby/code_object/module_object'

require 'inch/language/ruby/evaluation/base'
require 'inch/language/ruby/evaluation/namespace_object'
require 'inch/language/ruby/evaluation/class_object'
require 'inch/language/ruby/evaluation/class_variable_object'
require 'inch/language/ruby/evaluation/constant_object'
require 'inch/language/ruby/evaluation/method_object'
require 'inch/language/ruby/evaluation/module_object'

require 'inch/language/ruby/roles/base'
require 'inch/language/ruby/roles/missing'
require 'inch/language/ruby/roles/object'
require 'inch/language/ruby/roles/method'
require 'inch/language/ruby/roles/method_parameter'
require 'inch/language/ruby/roles/namespace'
require 'inch/language/ruby/roles/constant'
require 'inch/language/ruby/roles/class_variable'
