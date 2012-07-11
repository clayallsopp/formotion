describe "Submit Row" do
  before do
    row_settings = {
      title: "Submit",
      key: :submit,
      type: :submit,
    }
    @row = Formotion::Row.new(row_settings)
    @row.reuse_identifier = 'test'
  end

  it "should initialize with correct settings" do
    @row.object.class.should == Formotion::RowType::SubmitRow
  end

  it "should submit on select" do
    fake_delegate = FakeDelegateClass.new
    @row.object.on_select(nil, fake_delegate)
    fake_delegate.submit_called.should == true
  end
end

class FakeDelegateClass
  attr_accessor :submit_called
  def submit
    self.submit_called = true
  end
end