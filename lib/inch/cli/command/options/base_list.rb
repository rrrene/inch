module Inch
  module CLI
    module Command
      module Options
        class BaseList < Base
          attribute :full, false
          attribute :visibility, [:public, :protected]
          attribute :namespaces
          attribute :undocumented
          attribute :depth

          def parse(args)
            opts = OptionParser.new
            opts.banner = usage

            descriptions.each do |text|
              opts.separator "  " + text
            end

            set_options(opts)
            parse_yardopts_options(opts, args)
            parse_options(opts, args)

            @paths = get_paths(args)
          end

          def set_options(opts)
            list_options(opts)
            common_options(opts)

            yardopts_options(opts)
          end

          protected

          def list_options(opts)
            opts.separator ""
            opts.separator "List options:"

            opts.on("--all", "Show all objects in the output") do
              @full = true
            end

            opts.on("--only-namespaces", "Only show namespaces (classes, modules)") do
              @namespaces = :only
            end
            opts.on("--no-namespaces", "Only show namespace children (methods, constants, attributes)") do
              @namespaces = :none
            end

            opts.on("--no-public", "Do not show public objects") do
              set_visibility :public, false
            end
            opts.on("--no-protected", "Do not show protected objects") do
              set_visibility :protected, false
            end
            opts.on("--private", "Show private objects") do
              set_visibility :private, true
            end

            opts.on("--only-undocumented", "Only show undocumented objects") do
              @undocumented = :only
            end
            opts.on("--no-undocumented", "Only show documented objects") do
              @undocumented = :none
            end

            opts.on("--depth [DEPTH]", "Only show objects up to a given DEPTH in the class tree") do |depth|
              @depth = depth.to_i
            end
          end

          def set_visibility(_visibility, true_or_false)
            if true_or_false
              visibility.push(_visibility)
            else
              visibility.delete(_visibility)
            end
          end
        end
      end
    end
  end
end
