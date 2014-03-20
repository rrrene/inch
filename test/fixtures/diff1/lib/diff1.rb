class Foo
  # A complicated method
  def b(o, i, *args, &block)
    # ... snip ...
  end

  # An example of a method that takes a parameter (+param1+)
  # and does nothing.
  #
  # Returns nil
  def c(param1)
  end

  def d
    "#{self.class}_#{id}.foo"
  end
end
