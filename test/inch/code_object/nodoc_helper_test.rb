require File.expand_path(File.dirname(__FILE__) + '/../../test_helper')

describe ::Inch::CodeObject::NodocHelper do
  before do
    Dir.chdir fixture_path(:simple)
    @source_parser = Inch::SourceParser.run(["lib/**/*.rb"])
  end

  it "should return true for explicitly tagged objects" do
    [
      "Foo::Qux",
      "Foo::Qux#method_with_implicit_nodoc",
      "Foo::Qux::Quux#method_with_private_tag",
      "Foo::Qux::Quux#method_with_explicit_nodoc",
    ].each do |query|
      m = @source_parser.find_object(query)
      assert m.nodoc?, "there should be nodoc? for #{query}"
    end
  end

  it "should return false for other objects" do
    m = @source_parser.find_object("Foo::Qux::Quux#method_without_nodoc")
    refute m.nodoc?
  end

end
