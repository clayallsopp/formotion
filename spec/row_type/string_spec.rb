describe "String Row" do
  before do
    row_settings = {
      title: "String",
      key: :string,
      type: :string,
    }
    @row = Formotion::Row.new(row_settings)
    @row.reuse_identifier = 'test'
  end

  it "should initialize with correct settings" do
    @row.object.class.should == Formotion::RowType::StringRow
  end

  # Keyboard
  it "should use default keyboard" do
    cell = @row.make_cell
    @row.text_field.keyboardType.should == UIKeyboardTypeDefault
  end

end