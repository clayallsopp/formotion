describe "FormController/SubmitRow" do
  tests Formotion::FormController

  # By default, `tests` uses @controller.init
  # this isn't ideal for our case, so override.
  def controller
    row_settings = {
      title: "Submit",
      type: :submit
    }
    @form ||= Formotion::Form.new(
      sections: [{
        rows:[row_settings]
    }])

    @controller ||= Formotion::FormController.alloc.initWithForm(@form)
  end

  def submit_row
    @form.sections.first.rows.first
  end

  it "should call .submit when tapped" do
    @form.on_submit do
      @submitted = true
    end
    tap("Submit")
    @submitted.should == true
  end
end