require 'inch/utils/weighted_list'

module Inch
  module API
    class Suggest < Filter
      def initialize(codebase, options)
        super
        @options = Options::Suggest.new(options)
      end

      def files
        list = files_sorted_by_importance
        how_many = @options.file_count || list.size
        list[0...how_many]
      end

      # @return [Array] the +@options.object_count+ objects the API suggests
      def objects
        filter_objects_to_display
      end

      # @return [Array] all the objects that match +@options+
      def all_objects
        relevant_objects
      end

      private

      # @return [Fixnum] how many objects should be displayed in the output
      def object_count
        @options.object_count
      end

      # @return [Array<Fixnum>]
      #   how many objects of each grade should be displayed in the output
      def object_list_counts
        @options.grade_weights.map { |w| w * object_count }
      end

      # @return [Array] the objects that should be displayed in the output
      def filter_objects_to_display
        graded_list = []
        @options.grades_to_display.map do |grade|
          r = grade_list(grade)
          arr = select_by_priority(r.objects, @options.object_min_priority)
          arr = arr.select { |o| o.score <= @options.object_max_score }
          graded_list << arr
        end

        weighted_list = Utils::WeightedList.new(graded_list, object_list_counts)

        list = Codebase::Objects.sort_by_priority(weighted_list.to_a.flatten)

        list = list[0...object_count] if list.size > object_count
        list
      end

      def files_sorted_by_importance
        list = all_filenames(relevant_objects).uniq.map do |filename|
          Evaluation::File.for(filename, relevant_objects)
        end

        priority_list = list.select do |f|
          relevant_grades.include?(f.grade) &&
            relevant_priorities.include?(f.priority)
        end

        Codebase::Objects.sort_by_priority(
          priority_list.empty? ? list : priority_list)
      end

      def all_filenames(_objects)
        codebase.objects.map do |o|
          o.files.map(&:filename)
        end.flatten
      end

      # Returns the unique grades assigned to objects
      #
      #   grades # => [:A, :B, :C, :U]
      #
      # @return [Array<Symbol>]
      def grades
        codebase.objects.map(&:grade).uniq
      end

      def grade_list(grade_symbol)
        grade_lists.find { |r| r.grade.to_sym == grade_symbol }
      end

      def select_by_priority(list, min_priority)
        list.select { |o| o.priority >= min_priority }
      end

      def relevant_grades
        grades.size >= 2 ? grades[-2..-1] : [grades.last].compact
      end

      def relevant_objects
        @relevant_objects ||= select_by_priority(codebase.objects,
                                                 @options.object_min_priority)
      end

      def relevant_priorities
        (@options.object_min_priority..99)
      end
    end
  end
end
