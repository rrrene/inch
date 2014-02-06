Inch::Config.run do
  # development!

  evaluation do
    grade(:A) do
      scores    80..100
      label     "Seems really good"
      color     :green
    end

    grade(:B) do
      scores    50...80
      label     "Proper documentation present"
      color     :yellow
    end

    grade(:C) do
      scores    1...50
      label     "Needs work"
      color     :green
    end

    grade(:U) do
      scores    0..0
      label     "Undocumented"
      color     :color141
      bg_color  :color105
    end

    schema(:ConstantObject) do
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
