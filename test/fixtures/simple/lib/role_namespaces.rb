
# @deprecated
# @see PureNamespace
PUBLIC_ROOT_CONSTANT = :foo

class String
  def foobar
    self + 'foobar!'
  end
end

module InchTest
  # You would want to use it like this:
  #
  #  CodeExample.new
  #
  class CodeExample
  end

  # You would want to use it like this:
  #
  #  CodeExample.new
  #
  #  CodeExample.new # => something
  #
  class MultipleCodeExamples
  end

  module PureNamespace
  end

  # @deprecated
  # @see PureNamespace
  module ManyChildren
    class Base0; end
    class Base1; end
    class Base2; end
    class Base3; end
    class Base4; end
    class Base5; end
    class Base6; end
    class Base7; end
    class Base8; end
    class Base9; end
    class Base10; end
    class Base11; end
    class Base12; end
    class Base13; end
    class Base14; end
    class Base15; end
    class Base16; end
    class Base17; end
    class Base18; end
    class Base19; end
    class Base20; end
    class Base21; end
  end

  module ManyAttributes
    attr_accessor :base0
    attr_accessor :base1
    attr_accessor :base2
    attr_accessor :base3
    attr_accessor :base4
    attr_accessor :base5
    attr_accessor :base6
  end
end
