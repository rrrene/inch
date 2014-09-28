module Inch
  module Language
    module Nodejs
    end
  end
end

require 'inch/language/nodejs/provider/jsdoc'

require 'inch/language/nodejs/code_object/base'
require 'inch/language/nodejs/code_object/module_object'
require 'inch/language/nodejs/code_object/function_object'
require 'inch/language/nodejs/code_object/member_object'

require 'inch/language/nodejs/evaluation/base'
require 'inch/language/nodejs/evaluation/module_object'
require 'inch/language/nodejs/evaluation/function_object'
require 'inch/language/nodejs/evaluation/member_object'

require 'inch/language/nodejs/roles/base'
require 'inch/language/nodejs/roles/object'
require 'inch/language/nodejs/roles/module'
require 'inch/language/nodejs/roles/function'
require 'inch/language/nodejs/roles/function_parameter'
require 'inch/language/nodejs/roles/member'
