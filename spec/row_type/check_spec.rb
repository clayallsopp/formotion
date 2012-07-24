describe "Check Row" do
  tests_row :check

  it "should initialize with correct settings" do
    @row.object.class.should == Formotion::RowType::CheckRow
  end

  # Value
  it "should be unchecked by default" do
    cell = @row.make_cell
    cell.accessoryType.should == UITableViewCellAccessoryNone
  end

  it "should be checked when true" do
    @row.value = true
    cell = @row.make_cell
    cell.accessoryType.should == UITableViewCellAccessoryCheckmark
  end

  it "should bind its accessory" do
    @row.value = true
    cell = @row.make_cell

    @row.value = false
    cell.accessoryType.should == UITableViewCellAccessoryNone
  end
end