module Foo
  # Redirect to the given URL
  # @param url [String] the destination URL
  # @param status [Fixnum] the http code
  def method_with_named_parameter(url, status: 302)
  end
end
