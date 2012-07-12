describe "FormController/TextRow" do
  tests Formotion::FormController

  # By default, `tests` uses @controller.init
  # this isn't ideal for our case, so override.
  def controller
    row_settings = {
      title: "Text",
      key: :text,
      type: :text
    }
    @form ||= Formotion::Form.new(
      sections: [{
        rows:[row_settings]
    }])

    @controller ||= Formotion::FormController.alloc.initWithForm(@form)
  end

  def text_row
    @form.sections.first.rows.first
  end

  after do
    text_row.object.dismissKeyboard
  end

  it "should pop open the keyboard when tapped" do
    @notif = App.notification_center.observe UIKeyboardDidShowNotification do |notification|
      @did_show = true
    end
    tap("Text")
    wait 1 do
      @did_show.should == true
      App.notification_center.unobserve @notif
    end
  end

  it "should close the keyboard when tapped again" do
    @notif = App.notification_center.observe UIKeyboardDidHideNotification do |notification|
      @did_hide = true
    end

    tap("Text")
    wait 1 do
      tap("Text")
      wait 1 do
        @did_hide.should == true
        App.notification_center.unobserve @notif
      end
    end
  end

  it "should change value of row when typing" do
    tap("Text")
    text_row.object.field.text = "Hello"
    text_row.object.field.delegate.textViewDidChange(text_row.object.field)
    text_row.value.should == "Hello"
  end
end