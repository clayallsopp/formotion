# Methods which use blocks for UITextFieldDelegate methods.
# EX
# field.should_end? do |text_field|
#   if text_field.text != "secret"
#     return false
#   end
#   true
# end
#
# Also includes an on_change method, which calls after the text
# has changed (there is no UITextFieldDelegate equivalent.)
# EX
# field.on_change do |text_field|
#   p text_field.text
# end

class UITextField
  attr_accessor :menu_options_enabled

  def canPerformAction(action, withSender:sender)
    self.menu_options_enabled
  end

  # block takes argument textField; should return true/false
  def should_begin?(&block)
    add_delegate_method do
      @delegate.textFieldShouldBeginEditing_callback = block
    end
  end

  # block takes argument textField
  def on_begin(&block)
    add_delegate_method do
      @delegate.textFieldDidBeginEditing_callback = block
    end
  end

  # block takes argument textField; should return true/false
  def should_end?(&block)
    add_delegate_method do
      @delegate.textFieldShouldEndEditing_callback = block
    end
  end

  # block takes argument textField
  def on_end(&block)
    add_delegate_method do
      @delegate.textFieldDidBeginEditing_callback = block
    end
  end

  # block takes argument textField, range [NSRange], and string; should return true/false
  def should_change?(&block)
    add_delegate_method do
      @delegate.shouldChangeCharactersInRange_callback = block
    end
  end

  # block takes argument textField
  def on_change(&block)
    add_delegate_method do
      @delegate.on_change_callback = block
      self.addTarget(@delegate, action: 'on_change:', forControlEvents: UIControlEventEditingChanged)
    end
  end

  # block takes argument textField; should return true/false
  def should_clear?(&block)
    add_delegate_method do
      @delegate.textFieldShouldClear_callback = block
    end
  end

  # block takes argument textField; should return true/false
  def should_return?(&block)
    add_delegate_method do
      @delegate.textFieldShouldReturn_callback = block
    end
  end

  private
  def add_delegate_method
    # create strong reference to the delegate
    # (.delegate= only creates a weak reference)
    @delegate ||= UITextField_Delegate.new
    yield
    self.delegate = @delegate
  end
end

class UITextField_Delegate
  [:textFieldShouldBeginEditing, :textFieldDidBeginEditing,
   :textFieldShouldEndEditing, :textFieldDidEndEditing,
   :shouldChangeCharactersInRange, :textFieldShouldClear,
   :textFieldShouldReturn].each {|method|
    attr_accessor (method.to_s + "_callback").to_sym
  }

  # Called from
  # [textField addTarget:block
  #              action:'call'
  #    forControlEvents:UIControlEventEditingChanged],
  # NOT a UITextFieldDelegate method.
  attr_accessor :on_change_callback

  def textFieldShouldBeginEditing(theTextField)
    if self.textFieldShouldBeginEditing_callback
      return self.textFieldShouldBeginEditing_callback.call(theTextField)
    end
    true
  end

  def textFieldDidBeginEditing(theTextField)
    if self.textFieldDidBeginEditing_callback
      return self.textFieldDidBeginEditing_callback.call(theTextField)
    end
  end

  def textFieldShouldEndEditing(theTextField)
    if self.textFieldShouldEndEditing_callback
      return self.textFieldShouldEndEditing_callback.call(theTextField)
    end
    true
  end

  def textFieldDidEndEditing(theTextField)
    if self.textFieldDidEndEditing_callback
      return self.textFieldDidEndEditing_callback.call(theTextField)
    end
  end

  def textField(theTextField, shouldChangeCharactersInRange:range, replacementString:string)
    if self.shouldChangeCharactersInRange_callback
      return self.shouldChangeCharactersInRange_callback.call(theTextField, range, string)
    end
    true
  end

  def on_change(theTextField)
    if self.on_change_callback
      self.on_change_callback.call(theTextField)
    end
  end

  def textFieldShouldClear(theTextField)
    if self.textFieldShouldClear_callback
      return self.textFieldShouldClear_callback.call(theTextField)
    end
    true
  end

  def textFieldShouldReturn(theTextField)
    if self.textFieldShouldReturn_callback
      return self.textFieldShouldReturn_callback.call(theTextField)
    end
    true
  end
end