describe "Switch Row" do
  before do
    row_settings = {
      title: "Switch",
      key: :switch,
      type: :switch,
    }
    @row = Formotion::Row.new(row_settings)
    @row.reuse_identifier = 'test'
  end

  it "should initialize with correct settings" do
    @row.object.class.should == Formotion::RowType::SwitchRow
  end

  # Value
  it "should be off by default" do
    cell = @row.make_cell
    cell.accessoryView.on?.should == false
  end

  it "should be on when true" do
    @row.value = true
    cell = @row.make_cell
    cell.accessoryView.on?.should == true
  end
end