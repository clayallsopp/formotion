describe "Static Row" do
  tests_row :static

  it "should initialize with correct settings" do
    @row.object.class.should == Formotion::RowType::StaticRow
  end
end