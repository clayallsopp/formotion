describe "Template Row" do
  tests_row title: "Template", key: :template, type: :template,
            template: {type: :string}

  it "should initialize with correct settings" do
    @row.object.class.should == Formotion::RowType::TemplateRow
  end

  # Value
  it "should select default value" do
    cell = @row.make_cell
    @row.value.should == nil
  end
end