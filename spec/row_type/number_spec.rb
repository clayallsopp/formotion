describe "Number Row" do
  before do
    row_settings = {
      title: "Number",
      key: :number,
      type: :number,
    }
    @row = Formotion::Row.new(row_settings)
    @row.reuse_identifier = 'test'
  end

  it "should initialize with correct settings" do
    @row.object.class.should == Formotion::RowType::NumberRow
  end

  # Keyboard
  it "should use decimal keyboard" do
    cell = @row.make_cell
    @row.text_field.keyboardType.should == UIKeyboardTypeDecimalPad
  end

end