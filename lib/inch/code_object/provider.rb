module Inch
  module CodeObject
    module Provider
      def self.parse(dir, paths, excluded, type = :YARD)
        class_for(type).parse(dir, paths, excluded)
      end

      def self.class_for(type)
        eval("::Inch::CodeObject::Provider::#{type}")
      end
    end
  end
end

require_relative 'provider/yard'