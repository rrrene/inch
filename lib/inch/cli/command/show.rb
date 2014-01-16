module Inch
  module CLI
    module Command
      class Show < Base
        def description
          'Shows an object with its results'
        end

        def usage
          "Usage: inch show [paths] OBJECT_NAME [options]"
        end

        def run(*args)
          object_name = parse_arguments_and_object_names(args)
          run_object(object_name)
        end

        private

        def run_object(object_name)
          if object_name.empty?
            kill # "Provide a name to an object to show it's evaluation."
          else
            if object = source_parser.find_object(object_name)
              @objects = [object]
            else
              @objects = source_parser.find_objects(object_name)
            end
          end

          @objects.each do |o|
            print_object(o)
          end
        end

        def parse_arguments_and_object_names(args)
          parse_arguments(args)
          object_name = parse_object_names(args)
          run_source_parser(args)
          object_name
        end

        def parse_arguments(args)
          opts = OptionParser.new
          opts.banner = usage
          common_options(opts)
          
          yardopts_options(opts)
          parse_yardopts_options(opts, args)

          parse_options(opts, args)
        end

        # TOOD: really check the last parameters if they are globs, files 
        # or switches and find the object_name(s) that way
        def parse_object_names(args)
          object_name = args.pop || ""
          self.files.delete(object_name)
          object_name
        end

        LJUST = 20

        def print_object(o)
          trace
          trace_header(o.path, :magenta)

          print_file_info(o)
          print_doc_info(o)
          print_namespace_info(o)
          print_roles_info(o)

          echo "Score (min: #{o.evaluation.min_score}, max: #{o.evaluation.max_score})".ljust(40) + "#{o.score.to_i}".rjust(5)
          echo
        end

        def print_file_info(o)
          o.files.each do |f|
            echo "-> #{f[0]}:#{f[1]}".magenta
          end
          echo separator
        end

        def print_roles_info(o)
          if o.roles.empty?
            echo "No roles assigned.".dark
          else
            o.roles.each do |role|
              name = role.class.to_s.split('::Role::').last
              value = role.score.to_i
              score = value.abs.to_s.rjust(4)
              if value < 0
                score = ("-" + score).red
              elsif value > 0
                score = ("+" + score).green
              else
                score = " " + score
              end
              echo name.ljust(40) + score
              if role.max_score
                echo "  (set max score to #{role.max_score})"
              end
              if role.min_score
                echo "  (set min score to #{role.min_score})"
              end
            end
          end
          echo separator
        end

        def print_doc_info(o)
          if o.nodoc?
            echo "The object was tagged not to documented.".yellow
          else
            echo "Docstring".ljust(LJUST) + "#{o.has_doc? ? 'Yes' : 'No text'}"
            if o.method?
              echo "Parameters:".ljust(LJUST) + "#{o.has_parameters? ? '' : 'No parameters'}"
              o.parameters.each do |p|
                echo "  " + p.name.ljust(LJUST-2) + "#{p.mentioned? ? 'Text' : 'No text'} / #{p.typed? ? 'Typed' : 'Not typed'} / #{p.described? ? 'Described' : 'Not described'}"
              end
              echo "Return type:".ljust(LJUST) + "#{o.return_typed? ? 'Defined' : 'Not defined'}"
            end
          end
          echo separator
        end

        def print_namespace_info(o)
          if o.namespace?
            echo "Children (height: #{o.height}):"
            o.children.each do |child|
              echo "+ " + child.path.magenta
            end
            echo separator
          end
        end

        def echo(msg = "")
          trace edged(:magenta, msg)
        end

        def separator
          "-".magenta * (CLI::COLUMNS - 2)
        end
      end
    end
  end
end
