# Elixir's configuration

Inch::Config.register(:elixir) do
  codebase do
    object_provider :Reader
    include_files   []
    exclude_files   []
  end

  evaluation do
    schema(:ModuleObject) do
      docstring           1.0

      # optional:
      code_example_single 0.1
      code_example_multi  0.2
      unconsidered_tag    0.2
    end

    schema(:FunctionObject) do
      docstring           0.5
      parameters          0.4
      return_type         0.1
      return_description  0.3

      if object.questioning_name?
        parameters          parameters + return_type
        return_type         0.0
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
