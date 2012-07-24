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
    @row.subform.class.should == Formotion::Form
  end

  it "should push subform on select" do
    fake_delegate = FakeDelegateClass.new
    @row.object.on_select(nil, fake_delegate)
    fake_delegate.push_subform_called.should == true
  end
end

class FakeDelegateClass
  attr_accessor :push_subform_called
  def push_subform(form)
    self.push_subform_called = true
  end
end