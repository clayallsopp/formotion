describe "Submit Row" do
  tests_row :submit

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