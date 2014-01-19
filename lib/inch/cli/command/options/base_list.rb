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

            opts.on("--full", "Show all objects in the output") do
              @full = true
            end

            opts.on("--only-namespaces", "Only show namespaces (classes, modules)") do
              @namespaces = :only
            end
            opts.on("--no-namespaces", "Only show namespace children (methods, constants, attributes)") do
              @namespaces = :none
            end

            opts.on("--[no-]public", "Do [not] show public objects") do |v|
              set_visibility :public, v
            end
            opts.on("--[no-]protected", "Do [not] show protected objects") do |v|
              set_visibility :protected, v
            end
            opts.on("--[no-]private", "Do [not] show private objects") do |v|
              set_visibility :private, v
            end

            opts.on("--only-undocumented", "Only show undocumented objects") do
              @undocumented = :only
            end
            opts.on("--no-undocumented", "Only show documented objects") do
              @undocumented = :none
            end

            opts.on("--depth [DEPTH]", "Only show file counts") do |depth|
              @depth = depth.to_i
            end
          end

          def set_visibility(visibility, v)
            if v
              @visibility.push(visibility)
            else
              @visibility.delete(visibility)
            end
          end
        end
      end
    end
  end
end
