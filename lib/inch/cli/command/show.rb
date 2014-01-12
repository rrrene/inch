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
          if object = source_parser.find_object(args.first)
            @objects = [object]
          else
            @objects = source_parser.find_objects(args.first)
          end
        end
      end

      private

      LJUST = 20

      def print_object(o)
        echo "#{o.path}".magenta.bold
        o.files.each do |f|
          echo "-> #{f[0]}:#{f[1]}".magenta
        end
        echo "-".magenta * o.path.size
        #if o.has_doc?
        #  echo "#{o.docstring}".magenta
        #  echo "-".magenta * o.path.size
        #end
        echo "Text".ljust(LJUST) + "#{o.has_doc? ? 'Yes' : 'No text'}"
        if o.method?
          echo "Parameters:".ljust(LJUST) + "#{o.has_parameters? ? '' : 'No parameters'}"
          o.parameters.each do |p|
            echo "  " + p.name.ljust(LJUST-2) + "#{p.mentioned? ? 'Text' : 'No text'} / #{p.typed? ? 'Typed' : 'Not typed'} / #{p.described? ? 'Described' : 'Not described'}"
          end
          echo "Return type:".ljust(LJUST) + "#{o.return_typed? ? 'Defined' : 'Not defined'}"
        end

        if o.namespace?
          echo "Children:"
          o.children.each do |child|
            echo "+ " + child.path.magenta
          end
        end

        echo "Score:".ljust(LJUST) + "#{o.evaluation.score}"
        echo
      end

      def echo(msg = "", edge = "┃ ".magenta)
        trace edge + msg
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