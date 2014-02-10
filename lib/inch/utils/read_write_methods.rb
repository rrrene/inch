module Inch
  module Utils
    module ReadWriteMethods
      def rw_method(name)
        class_eval """
          def #{name}(value = nil)
            if value.nil?
              @#{name}
            else
              @#{name} = value
            end
          end
        """
      end

      def rw_methods(*names)
        [names].flatten.each { |name| rw_method(name) }
      end
    end
  end
end
