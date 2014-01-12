module Inch
  module CLI
    class Show < Base
      def description; 'Lists all objects with their results' end

      # Runs the commandline utility, parsing arguments and displaying a
      # list of objects
      #
      # @param [Array<String>] args the list of arguments.
      # @return [void]
      def run(*args)
        parse_arguments(*args)
        @objects.each do |o|
          print_object(o)
        end
      end

      def parse_arguments(*args)
        opts = OptionParser.new
        common_options(opts)
        parse_options(opts, args)
        if args.first
          if object = find_object(args.first)
            @objects = [object]
          else
            @objects = find_objects(args.first)
          end
        end
      end

      private

      LJUST = 20

      def print_object(o)
        print "#{o.path}".magenta.bold
        o.files.each do |f|
          print "-> #{f[0]}:#{f[1]}".magenta
        end
        print "-".magenta * o.path.size
        #if o.has_doc?
        #  print "#{o.docstring}".magenta
        #  print "-".magenta * o.path.size
        #end
        print "Text".ljust(LJUST) + "#{o.has_doc? ? 'Yes' : 'No text'}"
        if o.method?
          print "Parameters:".ljust(LJUST) + "#{o.has_parameters? ? '' : 'No parameters'}"
          o.parameter_doc.each do |p|
            print "  " + p.name.ljust(LJUST-2) + "#{p.mentioned? ? 'Text' : 'No text'} / #{p.typed? ? 'Typed' : 'Not typed'} / #{p.described? ? 'Described' : 'Not described'}"
          end
          print "Return type:".ljust(LJUST) + "#{o.return_typed? ? 'Defined' : 'Not defined'}"
        end

        if o.namespace?
          print "Children:"
          o.children.each do |child|
            print "+ " + child.path.magenta
          end
        end

        print "Score:".ljust(LJUST) + "#{o.evaluation.score}"
        print
      end

      def print(msg = "", edge = "┃ ".magenta)
        puts edge + msg
      end

      def find_object(path)
        objects.detect { |o| o.path == path }
      end

      def find_objects(path)
        objects.select { |o| o.path.start_with?(path) }
      end

      def objects
        @objects ||= source_parser.all_objects
      end

      def source_parser
        @source_parser ||= SourceParser.run(["{lib,app}/**/*.rb", "ext/**/*.c"])
      end
    end
  end
end