describe "Subform Row" do
  before do
    @subform_settings = {
      sections: [{
        rows: [{
          title: 'Hello',
          type: :static
        }]
      }]
    }

    row_settings = {
      title: "Subform",
      type: :subform,
      subform: @subform_settings
    }
    @row = Formotion::Row.new(row_settings)
    @row.reuse_identifier = 'test'
  end

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