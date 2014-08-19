class Foo
  # A complicated method
  def complicated(o, i, *args, &block)
    # ... snip ...
  end

  # The problem here is that ...
  #
  # @param *names [Array]
  # @return [String]
  def method_with_splat_parameter(*names)
  end

  # The problem here is that ...
  #
  # @param names [Array]
  # @return [String]
  def method_with_splat_parameter2(*names)
  end
end
