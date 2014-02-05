module Inch
  module Evaluation

    ConstantObject.criteria do
      docstring           1.0

      # optional:
      unconsidered_tag    0.2
    end

    ClassObject.criteria do
      docstring           1.0

      # optional:
      code_example_single 0.1
      code_example_multi  0.2
      unconsidered_tag    0.2
    end

    ModuleObject.criteria do
      docstring           1.0

      # optional:
      code_example_single 0.1
      code_example_multi  0.2
      unconsidered_tag    0.2
    end

    MethodObject.criteria do
      docstring           0.5
      parameters          0.4
      return_type         0.1
      return_description  0.3

      if object.constructor? || object.questioning_name?
        parameters          parameters + return_type
        return_type         0.0
      end

      unless object.has_parameters?
        return_description  docstring + parameters
        docstring           docstring + parameters
        parameters          0.0
      end

      # optional:
      code_example_single 0.1
      code_example_multi  0.25
      unconsidered_tag    0.2
    end

  end
end
