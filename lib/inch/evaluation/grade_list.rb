module Inch
  module Evaluation
    # These objects associate a grade with a group of objects
    #
    # @see .new_grade_lists
    class GradeList < Struct.new(:grade)
      extend Forwardable

      def_delegators :grade,
                     :scores, :label, :color, :bg_color, :to_s, :to_sym

      # Returns code_objects that received a score with the defined +scores+
      attr_reader :objects

      # Assigns code_objects that received a score with the defined +scores+
      #
      # @param arr [Array<CodeObject::Proxy>]
      # @return [Array<CodeObject::Proxy>]
      def objects=(arr)
        arr.each { |o| o.grade = grade }
        @objects = arr
      end
    end

    # Returns newly instanciated grade range objects
    #
    # @return [Array<GradeList>]
    def self.new_grade_lists
      Evaluation::Grade.all.map { |g| GradeList.new(g) }
    end
  end
end
