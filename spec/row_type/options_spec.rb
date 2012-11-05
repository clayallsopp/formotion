describe "Options Row" do
  tests_row title: "Options", key: :options, type: :options,
            items: ["First", "Second"]

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

  it "should bind value to control" do
    @row.value = 'Second'
    cell = @row.make_cell

    @row.value = "First"
    cell.accessoryView.selectedSegmentIndex.should == 0
  end

  it "should bind nil to no selected segment" do
    @row.value = 'Second'
    cell = @row.make_cell

    @row.value = nil
    cell.accessoryView.selectedSegmentIndex.should == UISegmentedControlNoSegment
  end

  it "should work with name-value items" do
    @row = Formotion::Row.new(title: "Options", key: :options, type: :options,
            items: [["First", 1], ["Second", 2]], value: 1)
    @row.reuse_identifier = 'test'
    cell = @row.make_cell

    cell.accessoryView.selectedSegmentIndex.should == 0

    @row.value = 2
    cell.accessoryView.selectedSegmentIndex.should == 1
  end
end