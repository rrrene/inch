require 'yard'

module Inch
  class Runner
    def initialize(args)
      YARD.parse("lib/**/*.rb") # parse the source tree
      all_object_proxies.each do |o|
        puts "#{o.path}"
        puts "has_doc?".ljust(20) + "#{o.has_doc? ? 'Y' : 'N'}"
        if o.type == :method
          puts "has_parameter_doc?".ljust(20) + "#{o.parameter_doc}"
          p o.object.tags
        end
        puts
      end
    end

    private

    def all_object_proxies
      all_objects.map do |o|
        CodeObjectProxy.for(o)
      end
    end

    def all_objects
      YARD::Registry.all
    end
  end
end
