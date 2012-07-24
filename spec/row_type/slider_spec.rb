describe "Slider Row" do
  tests_row title: "Slider", key: :slider, type: :slider,
            range: (1..100)

  it "should initialize with correct settings" do
    @row.object.class.should == Formotion::RowType::SliderRow
  end

  it "should build cell with slider" do
    cell = @row.make_cell
    cell.accessoryView.class.should == UISlider
  end

  # Value
  it "should set custom value" do
    @row.value = 50
    cell = @row.make_cell

    cell.accessoryView.value.should == 50
    @row.value.should == 50
  end

  it "should bind to row value" do
    @row.range = (50..100)
    @row.value = 25
    cell = @row.make_cell

    @row.value = 75
    cell.accessoryView.value.should == 75
  end

  # Range
  it "should use default range" do
    @row.range = nil
    cell = @row.make_cell

    cell.accessoryView.minimumValue.should == 1
    cell.accessoryView.maximumValue.should == 10
  end

  it "should use custom range values" do
    @row.range = (50..100)
    cell = @row.make_cell

    cell.accessoryView.minimumValue.should == 50
    cell.accessoryView.maximumValue.should == 100
  end
end