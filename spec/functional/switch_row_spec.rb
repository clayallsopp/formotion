describe "FormController/SwitchRow" do
  tests Formotion::FormController

  # By default, `tests` uses @controller.init
  # this isn't ideal for our case, so override.
  def controller
    row_settings = {
      title: "Switch",
      key: :switch,
      type: :switch,
      value: false
    }
    @form ||= Formotion::Form.new(
      sections: [{
        rows:[row_settings]
    }])

    @controller ||= Formotion::FormController.alloc.initWithForm(@form)
  end

  it "should change row value when tapped" do
    tap("Switch Switch")
    @form.sections[0].rows[0].value.should == true

    tap("Switch Switch")
    @form.sections[0].rows[0].value.should == false
  end
end