describe "Phone Row" do
  before do
    row_settings = {
      title: "Phone",
      key: :phone,
      type: :phone,
    }
    @row = Formotion::Row.new(row_settings)
    @row.reuse_identifier = 'test'
  end

  it "should initialize with correct settings" do
    @row.object.class.should == Formotion::RowType::PhoneRow
  end

  # Keyboard
  it "should use phone keyboard" do
    cell = @row.make_cell
    @row.text_field.keyboardType.should == UIKeyboardTypePhonePad
  end

end