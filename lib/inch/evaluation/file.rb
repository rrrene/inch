module Inch
  module Evaluation
    # Evaluation::File is used in the Suggest API/CLI to determine
    # the importance of files
    class File
      attr_accessor :filename, :objects

      def initialize(filename, objects)
        self.filename = filename
        self.objects = objects.select do |o|
          o.filename == filename
        end
      end

      # @note added to be compatible with code objects
      def fullname
        filename
      end

      #
      # grade, priority and score are not meant to be displayed in the CLI
      # they are just for internal evaluation purposes
      #

      def grade
        median(grades.sort_by(&:to_sym))
      end

      def priority
        median(priorities.sort)
      end

      def score
        objects.select(&:undocumented?).size
      end

      private

      def grades
        objects.map(&:grade)
      end

      def priorities
        objects.map(&:priority)
      end

      def median(sorted_list)
        index = (sorted_list.size / 2).round
        sorted_list[index]
      end

      class << self
        def for(filename, objects)
          @cache ||= {}
          if (file = @cache[filename])
            file
          else
            @cache[filename] = new(filename, objects)
          end
        end
      end
    end
  end
end
