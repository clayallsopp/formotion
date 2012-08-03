describe "FormController/TemplateRow" do
  tests Formotion::FormController

  # By default, `tests` uses @controller.init
  # this isn't ideal for our case, so override.
  def controller
    row_settings = {
      title: "Add element",
      key: :template,
      type: :template,
      value: ['Value'],
      template: {
        title: 'Element',
        type: :string,
        indented: true,
        deletable: true
      }
    }
    @form ||= Formotion::Form.new(
      sections: [{
        rows:[row_settings]
    }])

    @controller ||= Formotion::FormController.alloc.initWithForm(@form)
  end

  def new_row
    @form.sections.first.rows[-2]
  end

  after do
    @form = nil
    @controller = nil
  end

  it "should insert row" do
    tap("Add element")
    @form.sections.first.rows.size.should == 3
  end

  it "should remove row" do
    tap("Add element")
    new_row.object.on_delete(nil, nil)
    @form.sections.first.rows.size.should == 2
  end

  it "should render values as array" do

    tap("Add element")
    new_row.value = 'Value 2'

    tap("Add element")
    new_row.value = 'Value 3'

    @form.render[:template].should == ['Value', 'Value 2', 'Value 3']
  end
end