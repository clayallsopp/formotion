describe "FormController/SliderRow" do
  tests Formotion::FormController

  # By default, `tests` uses @controller.init
  # this isn't ideal for our case, so override.
  def controller
    row_settings = {
      title: "Slider",
      key: :slider,
      type: :slider,
      range: (1..100),
      value: 1
    }
    @form ||= Formotion::Form.new(
      sections: [{
        rows:[row_settings]
    }])

    @controller ||= Formotion::FormController.alloc.initWithForm(@form)
  end

  it "should change row value when sliding" do
    @form.sections[0].rows[0].value.should == 1
    drag("Slider Slider", :from => :left)
    @form.sections[0].rows[0].value.should == 100
  end
end
