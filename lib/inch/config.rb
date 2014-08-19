module Inch
  # Stores the configuration for Inch
  #
  # @see config/base.rb
  class Config
    class << self
      def instance(language = :ruby)
        @instances ||= {}
        @instances[language.to_s] ||= Config::Base.new(language)
      end

      def codebase(language = :ruby)
        instance(language).codebase
      end

      def run(language, &block)
        config = instance(language)
        config.update(&block) if block
        config
      end

      def base(&block)
        run(:__base__, &block)
      end

      def for(language, path = nil, &block)
        config = run(language, &block)
        config.codebase.update_via_yaml(path) if path
        config
      end
    end
  end
end

require "inch/config/base"
require "inch/config/evaluation"
require "inch/config/codebase"
