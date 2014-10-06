module Inch
  module Utils
    class BufferedUI < UI
      attr_reader :out, :err

      def initialize(_stdout = $stdout, _stderr = $stderr)
        @io = StringIO.new
        super(@io, @io)
      end

      def buffer
        @io.string
      end
    end
  end
end
