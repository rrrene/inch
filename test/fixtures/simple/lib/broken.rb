module Foo
  # The problem here is that the @param tag is not given the name of the
  # parameter it documents.
  #
  # @param [Encoding]
  # @return [String]
  def method_with_wrong_param_tag(e)

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
