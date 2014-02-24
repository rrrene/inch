module Foo
  # The problem here is that the @param tag is not given the name of the
  # parameter it documents.
  #
  # @param [Encoding]
  # @return [String]
  def method_with_wrong_param_tag(e)

  end

  # The problem here is that the @param tag does not describe the parameter
  #
  # @param [Encoding] e
  # @return [String]
  def method_with_empty_param_tag_text(e)
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

module YardError
  if defined? ::Deprecate
    Deprecate = ::Deprecate
  elsif defined? Gem::Deprecate
    Deprecate = Gem::Deprecate
  else
    class Deprecate; end
  end

  unless Deprecate.respond_to?(:skip_during)
    def Deprecate.skip_during; yield; end
  end

end
