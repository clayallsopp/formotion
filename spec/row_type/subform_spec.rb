describe "Subform Row" do
  tests_row title: "Subform", type: :subform,
            subform: {
              sections: [{
                rows: [{
                  title: 'Hello',
                  type: :static
                }]
              }]
            }

  it "should build cell with a label and an accessory" do
    cell = @row.make_cell
    cell.accessoryType.should == UITableViewCellAccessoryDisclosureIndicator
    cell.textLabel.text.should == 'Subform'
  end

  it "should build subform" do
    @row.subform.to_form.class.should == Formotion::Form
  end

  it "should push subform on select" do
    form = FakeForm.new
    @row.instance_variable_set("@section", form)

    @row.object.on_select(nil, nil)
    form.controller.push_subform_called.should == true
  end
end


class FakeForm
  def form
    self
  end

  def controller
    @controller ||= FakeControllerClass.new
  end
end

class FakeControllerClass
  attr_accessor :push_subform_called
  def push_subform(form)
    self.push_subform_called = true
  end
end