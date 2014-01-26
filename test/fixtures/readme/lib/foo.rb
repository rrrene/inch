class Foo
  # A complicated method
  def complicated(o, i, *args, &block)
    # ... snip ...
  end

  # An example of a method that takes a parameter (+param1+)
  # and does nothing.
  #
  # Returns nil
  def nothing(param1)
  end

  def filename
    "#{self.class}_#{id}.foo"
  end
end
