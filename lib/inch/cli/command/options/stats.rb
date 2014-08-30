module Inch
  module CLI
    module Command
      module Options
        class Stats < BaseList
          FORMATS = %w(text json yaml)

          attribute :format, FORMATS.first

          def list_options(opts)
            super
            opts.on('-f', '--format [FORMAT]', FORMATS,
                    'Set output FORMAT') do |format|
              @format = format
            end
          end
        end
      end
    end
  end
end
