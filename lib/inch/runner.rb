require 'yard'

module Inch
  class Runner
    def initialize(args)
      # TODO: provide a switch to ignore completely undocumented objects
      run_yard
      
      all_object_proxies.sort_by do |o|
        o.evaluation.score
      end.reverse.each do |o|
        puts "#{o.evaluation.score.to_s.rjust(4)} #{o.path}"
        #puts "# has_doc?".ljust(20) + "#{o.has_doc? ? 'Y' : 'N'}"
        #if o.type == :method
        #  puts "# Parameters:"
        #  o.parameter_doc.each do |p|
        #    puts "#   " + p.name.ljust(20) + "#{p.mentioned? ? 'M' : '-'} #{p.typed? ? 'T' : '-'} #{p.described? ? 'D' : '-'}"
        #  end
        #  puts "# Return type: #{o.return_typed? ? 'Y' : 'N'}"
        #end
        #puts "# Score: #{o.evaluation.score}"
        #puts
      end
    end

    private

    def all_object_proxies
      all_objects.map do |o|
        CodeObject::Proxy.for(o)
      end.sort_by(&:path)
    end

    def all_objects
      YARD::Registry.all
    end

    # Parses the source tree
    def run_yard
      YARD.parse("lib/**/*.rb") 
    end
  end
end
