class Foo
  def public_method
  end
  public :public_method


  def protected_method
  end
  protected :protected_method

  def private_method
  end
  private :private_method

  # @private
  def method_with_private_tag
  end
end