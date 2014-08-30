module Inch
  module CLI
    module Command
      module Options
        class BaseObject < Base
          attribute :object_names, []

          def parse(args)
            opts = OptionParser.new
            opts.banner = usage

            descriptions.each do |text|
              opts.separator '  ' + text
            end

            set_options(opts)
            parse_yardopts_options(opts, args)
            parse_options(opts, args)

            @object_names = parse_object_names(args)
            @paths = get_paths(args)
          end

          def set_options(opts)
            common_options(opts)

            yardopts_options(opts)
          end

          private

          def parse_object_names(args)
            arguments = Arguments.new(args)
            object_names = arguments.object_names
            object_names.each do |n|
              @yard_files.delete(n)
              args.delete(n)
            end
            object_names
          end
        end
      end
    end
  end
end
