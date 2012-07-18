describe "Picker Row" do
  before do
    row_settings = {
      title: "Picker",
      key: :picker,
      type: :picker,
      items: ["Ruby", "Motion"],
      value: "Motion"
    }
    @row = Formotion::Row.new(row_settings)
    @row.reuse_identifier = 'test'
  end

  it "should initialize with correct settings" do
    @row.object.class.should == Formotion::RowType::PickerRow
  end

  it "should build cell with picker as input view of text_field" do
    cell = @row.make_cell

    @row.text_field.inputView.class.should == UIPickerView
  end

  it "should start ui picker at custom value" do
    cell = @row.make_cell

    @row.text_field.inputView.selectedRowInComponent(0).should == 1
  end

  it "should have text field the custom value" do
    cell = @row.make_cell

    @row.text_field.text.should == "Motion"
  end
end