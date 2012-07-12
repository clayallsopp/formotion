describe "Email Row" do
  before do
    row_settings = {
      title: "Email",
      key: :email,
      type: :email,
    }
    @row = Formotion::Row.new(row_settings)
    @row.reuse_identifier = 'test'
  end

  it "should initialize with correct settings" do
    @row.object.class.should == Formotion::RowType::EmailRow
  end

  # Keyboard
  it "should use email keyboard" do
    cell = @row.make_cell
    @row.text_field.keyboardType.should == UIKeyboardTypeEmailAddress
  end

end