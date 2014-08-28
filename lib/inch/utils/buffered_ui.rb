module Inch
  module Utils
    class BufferedUI < UI
      attr_reader :out, :err

      def initialize(stdout = $stdout, stderr = $stderr)
        @io = StringIO.new
        super(@io, @io)
      end

      def buffer
        @io.string
      end
    end
  end
end
