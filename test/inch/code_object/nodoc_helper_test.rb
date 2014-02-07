require File.expand_path(File.dirname(__FILE__) + '/../../test_helper')

describe ::Inch::CodeObject::NodocHelper do
  before do
    @codebase = Inch::Codebase.parse(fixture_path(:simple), ["lib/**/*.rb"])
  end

  it "should return true for explicitly or implicitly tagged objects" do
    [
      "Foo::Qux",
      "Foo::Qux#method_with_implicit_nodoc",
      "Foo::Qux::Quux#method_with_private_tag",
      "Foo::Qux::Quux#method_with_explicit_nodoc",
      "Foo::Qux::Quux::PRIVATE_VALUE",
      "Foo::HiddenClass",
      "Foo::HiddenClass::EvenMoreHiddenClass",
      "Foo::HiddenClass::EvenMoreHiddenClass#method_with_implicit_nodoc",
      "Foo::HiddenClassViaTag",
      "Foo::HiddenClassViaTag#some_value",
    ].each do |query|
      m = @codebase.objects.find(query)
      assert m.nodoc?, "nodoc? should return true for #{query}"
    end
  end

  it "should return false for other objects" do
    [
      "Foo::Qux::Quux#method_without_nodoc",
      "Foo::Qux::Quux::PUBLIC_VALUE",
      "Foo::Qux::DOCCED_VALUE",
      "Foo::HiddenClass::EvenMoreHiddenClass::SuddenlyVisibleClass",
      "Foo::HiddenClass::EvenMoreHiddenClass::SuddenlyVisibleClass#method_with_implicit_doc",
    ].each do |query|
      m = @codebase.objects.find(query)
      refute m.nodoc?, "nodoc? should return false for #{query}"
    end
  end

end
