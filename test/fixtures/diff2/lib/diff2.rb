class Foo
  # New method
  #
  # Returns a string.
  def a
  end

  # A complicated method
  #
  # @param o [String]
  # @param i [String]
  # @param args [Array]
  # @param block [Proc]
  # @return [void]
  def b(o, i, *args, &block)
    # ... snip ...
  end

  # An example of a method that takes a parameter (+param1+)
  # and does nothing.
  #
  # Returns nil
  def c(param1)
  end
end
