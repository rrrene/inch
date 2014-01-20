# encoding: utf-8

require 'rake'
require 'rake/tasklib'

module Inch
  module Rake
    class Suggest < ::Rake::TaskLib
      attr_accessor :name
      attr_accessor :args

      def initialize(name = "doc:suggest", *args, &block)
        @name = name
        @args = args
        block.call(self) if block

        desc "Suggest objects to add documention to"
        task(@name) { suggest }
      end

      def suggest
        CLI::Command::Suggest.run(*@args)
      end
    end
  end
end
