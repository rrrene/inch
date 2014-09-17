class ViciousAliasCycle < Hash #:nodoc:
  # horrible hack to restore Hash#delete
  alias :__delete__ :delete
  include BaseApi
  alias :api_delete :delete
  alias :delete :__delete__
  remove_method :__delete__
end
