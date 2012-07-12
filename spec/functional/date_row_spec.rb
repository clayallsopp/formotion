describe "FormController/DateRow" do
  tests Formotion::FormController

  # By default, `tests` uses @controller.init
  # this isn't ideal for our case, so override.
  def controller
    row_settings = {
      title: "Date",
      key: :date,
      type: :date,
      value: 1341273600
    }
    @form ||= Formotion::Form.new(
      sections: [{
        rows:[row_settings]
    }])

    @controller ||= Formotion::FormController.alloc.initWithForm(@form)
  end

  def date_row
    @form.sections.first.rows.first
  end

  def picker
    date_row.object.picker
  end

  after do
    date_row.text_field.resignFirstResponder
    wait 1 do
    end
  end

  it "should open a the picker when tapped" do
    notif = App.notification_center.observe UIKeyboardDidShowNotification do |notification|
      @did_show = true
    end

    picker.superview.should == nil
    tap("Date")
    picker.superview.should.not == nil

    wait 1 do
      @did_show.should == true
    end
  end

  it "should change row value when picked" do
    tap("Date")

    wait 1 do
      # RubyMotion has some memory crashes if you don't make this an ivar/retain it.
      @march_26 = 701568000
      new_date = NSDate.dateWithTimeIntervalSince1970(@march_26).retain
      picker.setDate(new_date, animated: true)
      wait 1 do
        picker.sendActionsForControlEvents(UIControlEventValueChanged)
        self.date_row.value.should == @march_26
      end
    end
  end
end