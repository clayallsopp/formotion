# Methods which use blocks for UITextViewDelegate methods.
# EX
# field.should_end? do |text_field|
#   if text_field.text != "secret"
#     return false
#   end
#   true
# end
#
# Also includes an on_change method, which calls after the text
# has changed (there is no UITextViewDelegate equivalent.)
# EX
# field.on_change do |text_field|
#   p text_field.text
# end

class UITextView
  attr_accessor :menu_options_enabled

  def canPerformAction(action, withSender:sender)
    self.menu_options_enabled
  end

  # block takes argument textView; should return true/false
  def should_begin?(&block)
    add_delegate_method do
      @delegate.textViewShouldBeginEditing_callback = block
    end
  end

  # block takes argument textView
  def on_begin(&block)
    add_delegate_method do
      @delegate.textViewDidBeginEditing_callback = block
    end
  end

  # block takes argument textView; should return true/false
  def should_end?(&block)
    add_delegate_method do
      @delegate.textViewShouldEndEditing_callback = block
    end
  end

  # block takes argument textView
  def on_end(&block)
    add_delegate_method do
      @delegate.textViewDidEndEditing_callback = block
    end
  end

  # block takes argument textView
  def on_change(&block)
    add_delegate_method do
      @delegate.textViewDidChange_callback = block
    end
  end

    # block takes argument textView, range [NSRange], and string; should return true/false
  def should_change?(&block)
    add_delegate_method do
      @delegate.shouldChangeCharactersInRange_callback = block
    end
  end

  private
  def add_delegate_method
    # create strong reference to the delegate
    # (.delegate= only creates a weak reference)
    @delegate ||= UITextView_Delegate.new
    yield
    self.delegate = @delegate
  end
end

class UITextView_Delegate
  [:textViewShouldBeginEditing, :textViewDidBeginEditing,
   :textViewShouldEndEditing, :textViewDidEndEditing,
   :textViewDidChange, :shouldChangeCharactersInRange].each {|method|
    attr_accessor (method.to_s + "_callback").to_sym
  }

  def textViewShouldBeginEditing(theTextView)
    if self.textViewShouldBeginEditing_callback
      return self.textViewShouldBeginEditing_callback.call(theTextView)
    end
    true
  end

  def textViewDidBeginEditing(theTextView)
    if self.textViewDidBeginEditing_callback
      return self.textViewDidBeginEditing_callback.call(theTextView)
    end
  end

  def textViewShouldEndEditing(theTextView)
    if self.textViewShouldEndEditing_callback
      return self.textViewShouldEndEditing_callback.call(theTextView)
    end
    true
  end

  def textView(textView, shouldChangeTextInRange:range, replacementText:text)
    if self.shouldChangeCharactersInRange_callback
      return self.shouldChangeCharactersInRange_callback.call(textView, range, text)
    end
    true
  end

  def textViewDidEndEditing(theTextView)
    if self.textViewDidEndEditing_callback
      return self.textViewDidEndEditing_callback.call(theTextView)
    end
  end

  def textViewDidChange(theTextView)
    if self.textViewDidChange_callback
      self.textViewDidChange_callback.call(theTextView)
    end
  end

end