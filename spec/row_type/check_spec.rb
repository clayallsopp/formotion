describe "Check Row" do
  before do
    row_settings = {
      title: "Check",
      key: :check,
      type: :check,
    }
    @row = Formotion::Row.new(row_settings)
    @row.reuse_identifier = 'test'
  end

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
end