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
      color     :red
    end

    grade(:U) do
      scores    0..0
      label     "Undocumented"
      color     :color141
      bg_color  :color105
    end

    priority(:N) do
      priorities  4..99
      arrow       "\u2191"
    end

    priority(:NE) do
      priorities  2...4
      arrow       "\u2197"
    end

    priority(:E) do
      priorities  0...2
      arrow       "\u2192"
    end

    priority(:SE) do
      priorities  -2...0
      arrow       "\u2198"
    end

    priority(:S) do
      priorities  -99...-2
      arrow       "\u2193"
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
