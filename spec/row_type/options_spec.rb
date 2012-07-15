describe "Options Row" do
  before do
    row_settings = {
      title: "Options",
      key: :options,
      type: :options,
      items: ['First', 'Second']
    }
    @row = Formotion::Row.new(row_settings)
    @row.reuse_identifier = 'test'
  end

  it "should initialize with correct settings" do
    @row.object.class.should == Formotion::RowType::OptionsRow
  end

  it "should build cell with segmented control" do
    cell = @row.make_cell
    cell.accessoryView.class.should == UISegmentedControl
  end

  # Value
  it "should select default value" do
    cell = @row.make_cell

    cell.accessoryView.selectedSegmentIndex.should == -1
    @row.value.should == nil
  end

  it "should select custom value" do
    @row.value = 'Second'
    cell = @row.make_cell

    cell.accessoryView.selectedSegmentIndex.should == 1
    @row.value.should == 'Second'
  end
end