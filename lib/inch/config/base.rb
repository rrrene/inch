module Inch
  # Stores the configuration for Inch
  #
  # @see config/defaults.rb
  class Config
    class Base
      attr_reader :language

      def initialize(language)
        @language = language.to_sym
      end

      def update(&block)
        instance_eval(&block)
        self
      end

      def codebase(&block)
        @codebase ||= Config::Codebase.new(@language)
        @codebase.update(&block) if block
        @codebase
      end

      def evaluation(&block)
        @evaluation ||= Config::Evaluation.new(@language)
        @evaluation.update(&block) if block
        @evaluation
      end
    end
  end
end
