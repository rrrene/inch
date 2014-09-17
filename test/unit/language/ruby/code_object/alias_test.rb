require File.expand_path(File.dirname(__FILE__) + '/../../../../test_helper')

describe ::Inch::Language::Ruby::CodeObject::MethodObject do
  before do
    @codebase = test_codebase(:ruby, :alias_cycle)
    @objects = @codebase.objects
  end

  describe 'Parser' do
    #
    it 'should not raise stack level too deep' do
      m = @objects.find('ViciousAliasCycle')
      m.score
    end
  end
end