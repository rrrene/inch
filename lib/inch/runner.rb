require 'yard'

module Inch
  class Runner
    def initialize(args)
      # TODO: provide a switch to ignore completely undocumented objects

      YARD.parse("lib/**/*.rb") # parse the source tree
      all_object_proxies.each do |o|
        puts "#{o.path}"
        puts "# has_doc?".ljust(20) + "#{o.has_doc? ? 'Y' : 'N'}"
        if o.type == :method
          puts "# Parameters:"
          o.parameter_doc.each do |p|
            puts "#   " + p.name.ljust(20) + "#{p.mentioned? ? 'M' : '-'} #{p.typed? ? 'T' : '-'} #{p.described? ? 'D' : '-'}"
          end
          puts "# Return type: #{o.return_typed? ? 'Y' : 'N'}"
        end
        puts "# Score: #{o.evaluation.score}"
        puts
      end
    end

    private

    def all_object_proxies
      all_objects.map do |o|
        CodeObject::Proxy.for(o)
      end
    end

    def all_objects
      YARD::Registry.all
    end
  end
end
