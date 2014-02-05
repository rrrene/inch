def root_method
end

module InchTest
  def bang_method!
  end

  def splat_method(*args)
  end

  def block_method(&block)
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
end
