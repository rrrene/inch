module Inch
  module Language
    module JavaScript
    end
  end
end

require 'inch/language/javascript/provider/jsdoc'

require 'inch/language/javascript/code_object/base'
require 'inch/language/javascript/code_object/module_object'
require 'inch/language/javascript/code_object/class_object'
require 'inch/language/javascript/code_object/function_object'
require 'inch/language/javascript/code_object/member_object'

require 'inch/language/javascript/evaluation/base'
require 'inch/language/javascript/evaluation/module_object'
require 'inch/language/javascript/evaluation/class_object'
require 'inch/language/javascript/evaluation/function_object'
require 'inch/language/javascript/evaluation/member_object'

require 'inch/language/javascript/roles/base'
require 'inch/language/javascript/roles/object'
require 'inch/language/javascript/roles/module'
require 'inch/language/javascript/roles/function'
require 'inch/language/javascript/roles/function_parameter'
require 'inch/language/javascript/roles/member'
