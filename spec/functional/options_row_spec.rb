describe "FormController/OptionsRow" do
  tests Formotion::FormController

  # By default, `tests` uses @controller.init
  # this isn't ideal for our case, so override.
  def controller
    row_settings = {
      title: "Options",
      key: :options,
      type: :options,
      items: ['One', 'Two']
    }
    @form ||= Formotion::Form.new(
      sections: [{
        rows:[row_settings]
    }])

    @controller ||= Formotion::FormController.alloc.initWithForm(@form)
  end

  it "should change row value when selecting segment" do
    tap "One"
    @form.sections[0].rows[0].value.should == "One"
    tap "Two"
    @form.sections[0].rows[0].value.should == "Two"
  end
end