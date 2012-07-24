describe "FormController/SubformRow" do
  tests Formotion::FormController

  # By default, `tests` uses @controller.init
  # this isn't ideal for our case, so override.
  def controller
    row_settings = {
      title: "Goto",
      type: :subform,
      subform: {
        title: 'Subform',
        sections: [{
          rows: [{
            title: 'Mordor',
            type: :static,
          }]
        }]
      }
    }
    @form ||= Formotion::Form.new(
      sections: [{
        rows:[row_settings]
    }])

    @controller ||= Formotion::FormController.alloc.initWithForm(@form)
  end

  it "should goto subform when tapped" do
    tap("Goto")
    controller.modalViewController.should != nil
    window.viewByName('Mordor').should != nil
  end
end