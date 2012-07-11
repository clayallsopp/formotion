describe "Static Row" do
  before do
    row_settings = {
      title: "Static",
      key: :static,
      type: :static,
    }
    @row = Formotion::Row.new(row_settings)
    @row.reuse_identifier = 'test'
  end

  it "should initialize with correct settings" do
    @row.object.class.should == Formotion::RowType::StaticRow
  end
end