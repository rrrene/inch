module Inch
  module Utils
    # Extend a class with ReadWriteMethods and you will gain the +rw_methods+
    # macro.
    #
    #   class User
    #     extend ReadWriteMethods
    #     rw_methods :name, :admin
    #   end
    #
    # This implements read methods that act as writer methods when called
    # with a value parameter:
    #
    #   user = User.new
    #   user.name # => nil
    #   user.name "Adam"
    #   user.name # => "Adam"
    #
    module ReadWriteMethods
      # Implements a read method that acts as writer if called with a value
      #
      # @return [void]
      def rw_method(name)
        class_eval ''"
          def #{name}(value = nil)
            if value.nil?
              @#{name}
            else
              @#{name} = value
            end
          end
        "''
      end

      # Implements multiple read(write) methods with the given +names+
      #
      # @param names [Array<String,Symbol>]
      # @return [void]
      def rw_methods(*names)
        [names].flatten.each { |name| rw_method(name) }
      end
    end
  end
end
