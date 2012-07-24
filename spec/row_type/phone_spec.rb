describe "Phone Row" do
  tests_row :phone

  it "should initialize with correct settings" do
    @row.object.class.should == Formotion::RowType::PhoneRow
  end

  # Keyboard
  it "should use phone keyboard" do
    cell = @row.make_cell
    @row.text_field.keyboardType.should == UIKeyboardTypePhonePad
  end

end