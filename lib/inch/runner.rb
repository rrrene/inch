module Inch
  class Runner
    def initialize(args)
      YARD.parse("lib/**/*.rb") # parse the source tree
      all_objects.each do |o|
        puts o.docstring
      end
    end

    def all_objects
      YARD::Registry.all
    end
  end
end