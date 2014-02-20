# Foo is the classical name for a module
class Foo
  # A complicated method
  # @return [void]
  def complicated
    # ... snip ...
  end

  # An example of a method that takes a parameter (+param1+)
  # and does nothing.
  #
  # param1 - The first param
  #
  # Returns a String or nil
  def nothing(param1)
  end

  private

  def filename
    "#{self.class}_#{id}.foo"
  end
end
