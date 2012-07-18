describe "FormController/PickerRow" do
  tests Formotion::FormController

  # By default, `tests` uses @controller.init
  # this isn't ideal for our case, so override.
  def controller
    row_settings = {
      title: "Picker",
      key: :picker,
      type: :picker,
      items: ["Ruby", "Motion"],
      value: "Motion"
    }
    @form ||= Formotion::Form.new(
      sections: [{
        rows:[row_settings]
    }])

    @controller ||= Formotion::FormController.alloc.initWithForm(@form)
  end

  def picker_row
    @form.sections.first.rows.first
  end

  def picker
    picker_row.object.picker
  end

  after do
    picker_row.text_field.resignFirstResponder
    wait 0.5 do
    end
  end

  it "should open a the picker when tapped" do
    notif = App.notification_center.observe UIKeyboardDidShowNotification do |notification|
      @did_show = true
    end

    picker.superview.should == nil
    tap("Picker")
    picker.superview.should.not == nil

    wait 0.5 do
      @did_show.should == true
    end
  end

  it "should change row value when picked" do
    tap("Picker")

    wait 0.5 do
      picker.selectRow(0, inComponent: 0, animated: true)
      picker_row.object.pickerView(picker, didSelectRow:0, inComponent:0)
      wait 0.5 do
        picker_row.value.should == "Ruby"
      end
    end
  end
end