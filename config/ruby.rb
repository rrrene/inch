# Ruby's configuration

Inch::Config.register(:ruby) do
  codebase do
    object_provider :YARD
    include_files   ['lib/**/*.rb', 'app/**/*.rb']
    exclude_files   []
  end

  evaluation do
    schema(:ConstantObject) do
      docstring           1.0

      # optional:
      unconsidered_tag    0.2
    end

    schema(:ClassVariableObject) do
      docstring           1.0

      # optional:
      unconsidered_tag    0.2
    end

    schema(:ClassObject) do
      docstring           1.0

      # optional:
      code_example_single 0.1
      code_example_multi  0.2
      unconsidered_tag    0.2
    end

    schema(:ModuleObject) do
      docstring           1.0

      # optional:
      code_example_single 0.1
      code_example_multi  0.2
      unconsidered_tag    0.2
    end

    schema(:MethodObject) do
      docstring           0.5
      parameters          0.4
      return_type         0.1
      return_description  0.3

      if object.constructor? || object.questioning_name?
        parameters          parameters + return_type
        return_type         0.0
      end

      if object.constructor?
        return_description  0.0
      end

      if !object.has_parameters? || object.setter?
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
