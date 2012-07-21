# Tests character row behavior on a string type
describe "String Row Type" do
  tests_row :string

  it "should initialize with correct settings" do
    @row.object.class.should == Formotion::RowType::StringRow
  end

  it "should build cell with textfield" do
    cell = @row.make_cell
    @row.text_field.class.should == UITextField
  end

  # Value
  it "should have no value by default" do
    cell = @row.make_cell
    @row.text_field.text.should == ''
  end

  it "should use custom value" do
    @row.value = 'init value'
    cell = @row.make_cell

    @row.text_field.text.should == 'init value'
  end

  # Placeholder
  it "should have no placeholder by default" do
    cell = @row.make_cell
    @row.text_field.placeholder.should == nil
  end

  it "should use custom placeholder" do
    @row.placeholder = 'placeholder'
    cell = @row.make_cell
    @row.text_field.placeholder.should == 'placeholder'
  end

  # Keyboard
  it "should use default keyboard" do
    cell = @row.make_cell
    @row.text_field.keyboardType.should == UIKeyboardTypeDefault
  end
end