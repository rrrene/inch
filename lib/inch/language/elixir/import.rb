module Inch
  module Language
    module Elixir
    end
  end
end

require 'inch/language/elixir/provider/reader'

require 'inch/language/elixir/code_object/base'
require 'inch/language/elixir/code_object/module_object'
require 'inch/language/elixir/code_object/function_object'
require 'inch/language/elixir/code_object/type_object'

require 'inch/language/elixir/evaluation/base'
require 'inch/language/elixir/evaluation/module_object'
require 'inch/language/elixir/evaluation/function_object'
require 'inch/language/elixir/evaluation/type_object'

require 'inch/language/elixir/roles/base'
require 'inch/language/elixir/roles/object'
require 'inch/language/elixir/roles/module'
require 'inch/language/elixir/roles/function'
require 'inch/language/elixir/roles/function_parameter'
require 'inch/language/elixir/roles/type'
