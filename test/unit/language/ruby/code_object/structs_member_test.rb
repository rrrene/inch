require File.expand_path(File.dirname(__FILE__) + '/../../../../test_helper')

describe ::Inch::Language::Ruby::CodeObject::ClassObject do
  before do
    @codebase = test_codebase(:ruby, :simple)
    @objects = @codebase.objects
  end

  describe 'Structs' do
    #
    it 'should recognize that the members are documented in the class docstring' do
      %w(StructWithRDoc StructWithRDocAsInheritedClass).each do |class_name|
        %w(type oid gen pos objstm).each do |member_name|
          m = @objects.find("#{class_name}##{member_name}")
          refute_equal 0, m.score, "#{class_name}##{member_name} should have score > 0"
          refute m.undocumented?, "#{class_name}##{member_name} should not be undocumented"
        end
      end
    end
  end
end
