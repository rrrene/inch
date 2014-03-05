module Inch
  # Stores the configuration for Inch
  #
  # @see config/defaults.rb
  class Config
    class << self
      attr_accessor :instance

      def codebase
        self.instance ||= Config::Base.new
        instance.codebase
      end

      def run(&block)
        self.instance ||= Config::Base.new
        instance.update(&block)
        instance
      end
    end
  end
end

require_relative 'config/base'
require_relative 'config/codebase'
