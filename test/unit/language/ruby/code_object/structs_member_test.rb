require File.expand_path(File.dirname(__FILE__) + '/../../../../test_helper')

describe ::Inch::Language::Ruby::CodeObject::ClassObject do
  before do
    @codebase = test_codebase(:ruby, :structs)
    @objects = @codebase.objects
  end

  describe 'Structs with RDoc comment mentioning members' do
    #
    it 'should recognize that the members are documented in the class docstring' do
      %w(StructWithRDoc StructWithRDocAsInheritedClass).each do |class_name|
        %w(type oid gen pos objstm).each do |member_name|
          m = @objects.find("#{class_name}##{member_name}")
          refute_equal 0, m.score, "#{class_name}##{member_name} should have score > 0"
          refute m.undocumented?, "#{class_name}##{member_name} should not be undocumented"
        end
        m = @objects.find("#{class_name}#member_without_doc")
        assert_equal 0, m.score, "#{class_name}#member_without_doc should have score == 0"
        assert m.undocumented?, "#{class_name}#member_without_doc should be undocumented"
      end
    end
  end

  describe 'Structs with YARD directives' do
    #
    it 'should recognize that the members are documented via directives' do
      %w(StructWithYardDirectivesOutside StructWithYardDirectivesAsInheritedClass StructWithYardDirectivesOutsideAsInheritedClass).each do |class_name|
        %w(email username).each do |member_name|
          m = @objects.find("#{class_name}##{member_name}")
          refute_equal 0, m.score, "#{class_name}##{member_name} should have score > 0"
          refute m.undocumented?, "#{class_name}##{member_name} should not be undocumented"
        end
        m = @objects.find("#{class_name}#member_without_doc")
        assert_equal 0, m.score, "#{class_name}#member_without_doc should have score == 0"
        assert m.undocumented?, "#{class_name}#member_without_doc should be undocumented"
      end
    end
  end
end
