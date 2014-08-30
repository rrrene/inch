# encoding: utf-8

require 'rake'
require 'rake/tasklib'
require 'inch/cli'

module Inch
  # Holds all Rake tasks
  module Rake
    # Provides Rake task integration
    class Suggest < ::Rake::TaskLib
      # @return [String] name of the Rake task
      attr_accessor :name
      # @return [Array] arguments to be passed to Suggest.run
      attr_accessor :args

      # @param name [String] name of the Rake task
      # @param *args [Array] arguments to be passed to Suggest.run
      # @param &block [Proc] optional, evaluated inside the task definition
      def initialize(name = 'inch', *args, &block)
        @name = name
        @args = args
        block.call(self) if block

        desc 'Suggest objects to add documention to'
        task(@name) { suggest }
      end

      # @return [void]
      def suggest
        ::Inch::CLI::Command::Suggest.run(*@args)
      end
    end
  end
end
