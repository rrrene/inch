def root_method
end

module InchTest
  StructGetSet = Struct.new(:struct_getset)

  attr_accessor :attr_getset

  def manual_getset
  end

  def manual_getset=(val)
  end

  attr_reader :getter

  def manual_setter=(val)
  end

  attr_writer :attr_setter

  def bang_method!
  end

  def splat_method(*args)
  end

  def block_method(&block)
  end

  def yielding_method
    yield true if block_given?
  end

  def question_mark_method?
    if true
      bang_method!
    end
  end

  # @return [Boolean] something funny
  def question_mark_method_with_description?
  end

  # @return [Boolean] something funny
  def method_with_description_and_parameters?(user)
  end

  def many_parameters_method(a,b,c,d,e,f)
  end

  def alias_method
  end
  alias :am :alias_method

  def many_lines_method
    if true
      if true
        if true
          if true
            bang_method!
          end
        end
      end
    end
    if true
      if true
        if true
          if true
            bang_method!
          end
        end
      end
    end
    if true
      if true
        if true
          if true
            bang_method!
          end
        end
      end
    end
  end

  # @deprecated
  # @see InchTest
  def unconsidered_tags_method
  end
  public :public_method

  # @raise [ArgumentError] every time!
  def raising_method_with_comment
    raise ArgumentError
  end

  def raising_method
    raise ArgumentError
  end

  def public_method
  end

  def protected_method
  end
  protected :protected_method

  def private_method
  end
  private :private_method

  # @private
  def method_with_private_tag
  end

  # @api private
  def private_api_with_yard
  end

  # Internal: Normalize the filename.
  def internal_api_with_tomdoc
  end

  # Private: Normalize the filename.
  def private_method_with_tomdoc
  end

  # @return [Boolean] something funny
  def _aliased_method
  end
  alias _alias_method _aliased_method

end
