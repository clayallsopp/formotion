describe "Text Row" do
  tests_row :text

  it "should initialize with correct settings" do
    @row.object.class.should == Formotion::RowType::TextRow
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

  it "should bind row.value" do
    @row.value = 'init value'
    cell = @row.make_cell

    @row.value = "new value"
    @row.text_field.text.should == 'new value'
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

end