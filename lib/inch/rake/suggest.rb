# encoding: utf-8

require "rake"
require "rake/tasklib"

module Inch
  # Holds all Rake tasks
  module Rake
    class Suggest < ::Rake::TaskLib
      attr_accessor :name
      attr_accessor :args

      # @param name [String] name of the Rake task
      # @param *args [Array] arguments to be passed to Suggest.run
      # @param &block [Proc] optional, evaluated inside the task definition
      def initialize(name = "inch", *args, &block)
        @name = name
        @args = args
        block.call(self) if block

        desc "Suggest objects to add documention to"
        task(@name) { suggest }
      end

      def suggest
        ::Inch::CLI::Command::Suggest.run(*@args)
      end
    end
  end
end
