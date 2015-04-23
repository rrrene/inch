module Inch
  module Codebase
    class Proxy
      attr_reader :objects

      def initialize(language, provider)
        @objects = Codebase::Objects.new(language, provider.objects)
      end

      def self.parse(dir, config)
        provider = CodeObject::Provider.parse(dir, config)
        new(config.language, provider)
      end
    end
  end
end
