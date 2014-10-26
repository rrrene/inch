require File.expand_path(File.dirname(__FILE__) + '/../../../../test_helper')

describe ::Inch::Language::Ruby::CodeObject::MethodObject do
  before do
    @codebase = test_codebase(:ruby, :simple)
    @objects = @codebase.objects
  end

  describe 'Scores' do
    #
    it 'should not count tags that are transitive' do
      m = @objects.find('InchTest::Deprecated::ClassMethods')
      assert_equal 0, m.score
      assert m.undocumented?
    end

    it 'counts a @raise tag' do
      m = @objects.find('InchTest#raising_method_with_comment')
      assert m.score > 0
      refute m.undocumented?
    end

    it 'should not count a call to `raise`' do
      m = @objects.find('InchTest#raising_method')
      assert_equal 0, m.score
      assert m.undocumented?
    end

    it 'should not count a call to `yield`' do
      m = @objects.find('InchTest#yielding_method')
      assert_equal 0, m.score
      assert m.undocumented?
    end
  end

  describe 'Taggings' do
    #
    it 'should recognize forms of @private-tags' do
      %w( InchTest#method_with_private_tag
          InchTest#private_method_with_tomdoc).each do |fullname|
        m = @objects.find(fullname)
        assert m.tagged_as_private?
      end
    end

    it 'should recognize forms of internal-tags' do
      # @api private in YARD
      # Internal: in TomDoc
      %w( InchTest#private_api_with_yard
          InchTest#internal_api_with_tomdoc).each do |fullname|
        m = @objects.find(fullname)
        assert m.tagged_as_internal_api?
      end
    end
  end

  it 'should recognize undocumented methods without parameters' do
    m = @objects.find('Foo::Bar#method_without_doc')
    refute m.has_doc?
    refute m.has_parameters?
    refute m.return_mentioned?
    assert m.undocumented?

    assert_equal 0, m.score
  end

  it 'should recognize missing parameter documentation' do
    m = @objects.find('Foo::Bar#method_with_missing_param_doc')
    assert m.has_doc?
    assert m.has_parameters?
    assert m.return_mentioned?

    assert_equal 3, m.parameters.size
    p = m.parameter(:param1)
    assert p.mentioned?
    p = m.parameter(:param2)
    assert p.mentioned?

    # not mentioned
    p = m.parameter(:param3)
    refute p.mentioned?

    assert m.score
  end

  describe 'Documentation Styles' do
    #
    it 'should handle YARD when no additional docstring is given' do
      m = @objects.find('Foo::Bar#method_without_docstring')
      refute m.has_doc?
      assert m.has_parameters?
      assert m.return_mentioned?

      assert m.score
    end

    it 'should handle YARD when only @return is given' do
      m = @objects.find('Foo::Bar#method_without_params_or_docstring')
      refute m.has_doc?
      refute m.has_parameters?
      assert m.return_mentioned?
      refute m.return_described?

      assert m.score
    end

    it 'should handle unusable return value when only @return [void]' \
       ' is given' do
      m = @objects.find('Foo::Bar#method_without_usable_return_value')
      assert m.return_mentioned?
      assert m.return_described?

      assert m.score
    end

    it 'should handle RDoc' do
      m = @objects.find('Foo::Bar#method_with_rdoc_doc')
      assert m.has_doc?
      assert m.has_parameters?
      p = m.parameter(:param1)
      assert p.mentioned?         # mentioned in docs, correctly
      refute m.return_mentioned?

      assert m.score
    end

    it 'should handle other RDoc styles' do
      m = @objects.find('Foo::Bar#method_with_other_rdoc_doc')
      assert m.has_doc?
      assert m.has_parameters?
      p = m.parameter(:param1)
      assert p.mentioned?         # mentioned in docs, correctly
      p = m.parameter(:param2)
      assert p.mentioned?         # mentioned in docs, correctly
      p = m.parameter(:param3)
      assert p.mentioned?         # mentioned in docs, correctly
      refute m.return_mentioned?

      assert m.score
    end

    it 'should handle yet other RDoc styles' do
      m = @objects.find('Foo::Bar#method_with_yet_another_rdoc_doc')
      assert m.has_doc?
      assert m.has_parameters?
      p = m.parameter(:param1)
      assert p.mentioned?         # mentioned in docs, correctly
      p = m.parameter(:param2)
      assert p.mentioned?         # mentioned in docs, correctly

      assert m.score
    end

    it 'should handle unstructured doc styles' do
      m = @objects.find('Foo::Bar#method_with_unstructured_doc')
      assert m.has_doc?
      assert m.has_parameters?
      p = m.parameter(:param1)
      assert p.mentioned?         # mentioned in docs, correctly
      refute m.return_mentioned?

      assert m.score
    end

    it 'should handle unstructured doc styles with an undocumented param' do
      m = @objects.find('Foo::Bar#method_with_unstructured_doc_missing_params')
      assert m.has_doc?
      assert m.has_parameters?
      p = m.parameter(:format)
      refute p.mentioned?         # mentioned in docs, correctly
      refute m.return_mentioned?

      assert m.score
    end

    it 'should handle methods (without parameters) that have only a docstring' \
       ' (text comment)' do
      m = @objects.find('Foo::Bar#method_without_params_or_return_type')
      assert m.has_doc?
      refute m.has_parameters?
      refute m.return_mentioned?

      assert m.score
    end
  end

  describe 'Getter/Setter Handling' do

    it 'should recognize a getter method' do
      m = @objects.find('InchTest#getter')
      assert m.getter?, 'should be a getter'
      refute m.setter?
      refute m.has_doc?
      assert_equal 0, m.score
    end

    it 'should recognize a setter method' do
      m = @objects.find('InchTest#attr_setter=')
      refute m.getter?
      assert m.setter?, 'should be a setter'
      refute m.has_doc?
      assert_equal 0, m.score
    end

    it 'should recognize a manually defined setter method' do
      m = @objects.find('InchTest#manual_setter=')
      refute m.getter?
      assert m.setter?, 'should be a setter'
      refute m.has_doc?
      assert_equal 0, m.score
    end

    it 'should recognize a getter in a manually defined getter/setter pair' do
      m = @objects.find('InchTest#manual_getset')
      assert m.getter?, 'should be a getter'
      refute m.setter?
      refute m.has_doc?
      assert_equal 0, m.score
    end

    it 'should recognize a setter in a manually defined getter/setter pair' do
      m = @objects.find('InchTest#manual_getset=')
      refute m.getter?
      assert m.setter?, 'should be a setter'
      refute m.has_doc?
      assert_equal 0, m.score
    end

    it 'should recognize a getter in a getter/setter pair defined via' \
       ' attr_accessor' do
      m = @objects.find('InchTest#attr_getset')
      assert m.getter?, 'should be a getter'
      refute m.setter?
      refute m.has_doc?
      assert_equal 0, m.score
    end

    it 'should recognize a setter in a getter/setter pair defined via' \
       ' attr_accessor' do
      m = @objects.find('InchTest#attr_getset=')
      refute m.getter?
      assert m.setter?, 'should be a setter'
      refute m.has_doc?
      assert_equal 0, m.score
    end

    it 'should recognize a getter in a getter/setter pair defined via Struct' do
      m = @objects.find('InchTest::StructGetSet#struct_getset')
      assert m.getter?, 'should be a getter'
      refute m.setter?
      refute m.has_doc?
      assert_equal 0, m.score
    end

    it 'should recognize a setter in a getter/setter pair defined via Struct' do
      m = @objects.find('InchTest::StructGetSet#struct_getset=')
      refute m.getter?
      assert m.setter?, 'should be a setter'
      refute m.has_doc?
      assert_equal 0, m.score
    end

    it 'should recognize docs on a getter in a getter/setter pair defined via' \
       ' attr_accessor' do
      m = @objects.find('Attributes#username')
      refute_equal 0, m.score
      refute m.undocumented?
    end

    it 'should recognize docs on a setter in a getter/setter pair defined via' \
       ' attr_accessor' do
      m = @objects.find('Attributes#username=')
      refute_equal 0, m.score
      refute m.undocumented?
    end

    it 'should recognize splat parameter notation' do
      # it should assign the same score whether the parameter is
      # described with or without the splat (*) operator
      m1 = @objects.find('Foo#method_with_splat_parameter')
      m2 = @objects.find('Foo#method_with_splat_parameter2')
      assert_equal 1, m1.parameters.size
      assert_equal 1, m2.parameters.size
      assert_equal m1.score, m2.score
    end

    it 'should recognize alias methods and aliased methods' do
      m1 = @objects.find('InchTest#_aliased_method')
      m2 = @objects.find('InchTest#_alias_method')
      assert_equal m1.score, m2.score
    end
  end

  describe 'YARDs @!attribute directive on a class' do
    #
    it 'should work as a reader' do
      m = @objects.find('Attributes#email')
      refute_equal 0, m.score
      refute m.undocumented?
    end

    it 'should work as a writer' do
      m = @objects.find('Attributes#email=')
      refute_equal 0, m.score
      # refute m.undocumented?
      # NOTE: this is undocumented since there is no original_docstring
    end
  end

  describe 'YARDs @overload tag on methods' do
    #
    it 'should work with basic overloading' do
      list = []
      list << @objects.find('Overloading#rgb')
      list << @objects.find('Overloading#rgba')
      list << @objects.find('Overloading#change_color')
      list << @objects.find('Overloading#mix')
      list << @objects.find('Overloading#hooks')
      list << @objects.find('Overloading#identifiers')
      list << @objects.find('Overloading#params_only_in_overloads')
      list.each do |m|
        assert_equal 100, m.score, "#{m.fullname} did not get 100"
      end
    end

    it 'should work with a malformed @param tag in an overload tag' do
      m = @objects.find('Overloading#missing_param_names')
      refute m.has_doc? # it may be mentioned in the docs, but it's malformed.
    end

    it 'should work with several overload tags on the same method' do
      skip
      m = @objects.find('Overloading#many_overloads')
      assert_equal 1, count_roles(
        m, Inch::Language::Ruby::Evaluation::Role::Method::WithoutReturnDescription)
      assert_equal 1, count_roles(
        m, Inch::Language::Ruby::Evaluation::Role::Method::WithoutReturnType)
      assert_equal 1, count_roles(
        m, Inch::Language::Ruby::Evaluation::Role::MethodParameter::WithoutMention,
        'block')
    end

    it 'should work if @param tags are only present in the @overload tags,' \
       ' but not on the actual method' do
      m = @objects.find('Overloading#params_only_in_overloads')
      unexpected_roles = [
        Inch::Language::Ruby::Evaluation::Role::Object::WithoutCodeExample,
        Inch::Language::Ruby::Evaluation::Role::MethodParameter::WithoutMention,
        Inch::Language::Ruby::Evaluation::Role::MethodParameter::WithoutType
      ]
      assert_roles m, [], unexpected_roles
    end

    it 'should work with one param missing in the overload tag' do
      m = @objects.find('Overloading#one_param_missing_in_overload')
      unexpected_roles = [
        Inch::Language::Ruby::Evaluation::Role::Object::WithoutCodeExample
      ]
      expected_roles = [
        Inch::Language::Ruby::Evaluation::Role::MethodParameter::WithoutMention,
        Inch::Language::Ruby::Evaluation::Role::MethodParameter::WithoutType
      ]
      assert_roles m, expected_roles, unexpected_roles
    end
  end

  describe 'MISC' do
    #
    it 'should recognize named parameters in Ruby 2.1' do
      skip unless RUBY_VERSION =~ /^2/

      m = @objects.find('Foo#method_with_named_parameter')
      unexpected_roles = [
        Inch::Language::Ruby::Evaluation::Role::MethodParameter::WithoutMention,
        Inch::Language::Ruby::Evaluation::Role::MethodParameter::WithoutType
      ]
      assert_roles m, [], unexpected_roles
    end

    it 'should recognize indented parameter documentation' do
      skip # YARD cannot parse this

      m = @objects.find('Foo#method_with_indented_param_tag')
      unexpected_roles = [
        Inch::Language::Ruby::Evaluation::Role::MethodParameter::WithoutMention,
        Inch::Language::Ruby::Evaluation::Role::MethodParameter::WithoutType
      ]
      assert_roles m, [], unexpected_roles
    end

    it 'should recognize wrong parameter documentation' do
      m = @objects.find('Foo::Bar#method_with_wrong_doc')
      assert m.has_doc?
      assert m.has_parameters?
      assert m.return_mentioned?

      assert_equal 4, m.parameters.size
      p = m.parameter(:param1)
      assert p.mentioned?         # mentioned in docs, correctly
      refute p.wrongly_mentioned?
      p = m.parameter(:param2)
      refute p.mentioned?
      refute p.wrongly_mentioned? # not mentioned in docs at all
      p = m.parameter(:param3)
      refute p.mentioned?
      refute p.wrongly_mentioned? # not mentioned in docs at all

      p = m.parameter(:param4)
      assert p.mentioned?
      assert p.wrongly_mentioned? # mentioned in docs, but not present

      assert m.score
    end

    it 'should recognize fully-documented methods with parameters' do
      m = @objects.find('Foo::Bar#method_with_full_doc')
      assert m.has_doc?
      assert m.has_parameters?
      assert m.return_mentioned?

      assert_equal 2, m.parameters.size
      m.parameters.each do |param|
        assert param.mentioned?
        assert param.typed?
        assert param.described?
        refute param.wrongly_mentioned?
      end

      assert_equal 100, m.score
    end

    it 'should recognize question mark methods' do
      m = @objects.find('InchTest#question_mark_method?')
      refute m.has_doc?
      refute m.has_parameters?

      # assert it is zero, because YARD auto-assigns tags to these
      assert_equal 0, m.score
    end

    it 'should recognize question mark methods with description' do
      m = @objects.find('InchTest#question_mark_method_with_description?')
      refute m.has_doc?
      refute m.has_parameters?

      assert m.score > 0
      assert m.score >= 50 # TODO: don't use magic numbers
    end

    it 'should recognize question mark methods with description and' \
       ' parameters' do
      m = @objects.find('InchTest#method_with_description_and_parameters?')
      refute m.has_doc?
      assert m.has_parameters?

      assert m.score > 0
    end

    it 'should recognize the depth of methods' do
      m = @objects.find('#root_method')
      assert_equal 1, m.depth
      m = @objects.find('InchTest#getter')
      assert_equal 2, m.depth
      m = @objects.find('Foo::Bar#method_without_doc')
      assert_equal 3, m.depth
    end

    it 'should recognize docs on class variables' do
      m = @objects.find('Foo::@@class_variable')
      assert m.has_doc?
      refute m.undocumented?
      assert_equal 100, m.score
    end
  end
end
