module Inch
  # Stores the configuration for Inch
  #
  # @see config/base.rb
  class Config
    class << self
      def instance(language = :ruby)
        if (block = @blocks[language.to_s])
          config = Config::Base.new(language)
          config = config.update(&block)
          config
        else
          fail "Language not registered: #{language}"
        end
      end

      # Registers a configuration block for a given language.
      #
      # @return [void]
      def register(language, &block)
        @blocks ||= {}
        @blocks[language.to_s] = block
      end

      def codebase(language = :ruby)
        instance(language).codebase
      end

      def base(&block)
        Config::Base.new(:__base__).update(&block)
      end

      # Returns the Config object for a given +language+.
      # Optionally parses a given +path+ for inch.yml
      #
      # @return [Config::Base]
      def for(language, path = nil)
        config = instance(language)
        config.codebase.update_via_yaml(path) if path
        config
      end

      def namespace(language, submodule = nil)
        name = language.to_s.split('_').map { |w| w.capitalize }.join
        const = ::Inch::Language.const_get(name)
        const = const.const_get(submodule) unless submodule.nil?
        const
      end
    end
  end
end

require 'inch/config/base'
require 'inch/config/evaluation'
require 'inch/config/codebase'
