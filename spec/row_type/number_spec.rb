describe "Number Row" do
  tests_row :number

  it "should initialize with correct settings" do
    @row.object.class.should == Formotion::RowType::NumberRow
  end

  # Keyboard
  it "should use decimal keyboard" do
    cell = @row.make_cell
    @row.text_field.keyboardType.should == UIKeyboardTypeDecimalPad
  end

end