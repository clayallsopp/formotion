describe "Email Row" do
  tests_row :email

  it "should initialize with correct settings" do
    @row.object.class.should == Formotion::RowType::EmailRow
  end

  # Keyboard
  it "should use email keyboard" do
    cell = @row.make_cell
    @row.text_field.keyboardType.should == UIKeyboardTypeEmailAddress
  end

end