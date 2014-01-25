module Foo
  # The problem here is that the @param tag is not given the name of the
  # parameter it documents.
  #
  # @param [Encoding]
  # @return [String]
  def method_with_wrong_param_tag(e)

  end
end
