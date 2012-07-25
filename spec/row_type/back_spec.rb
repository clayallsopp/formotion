describe "Back Row" do
  tests_row :back

  it "should initialize with correct settings" do
    @row.object.class.should == Formotion::RowType::BackRow
  end

  it "should pop subform on select" do
    form = FakeForm.new
    @row.instance_variable_set("@section", form)
    @row.object.on_select(nil, nil)
    form.controller.pop_subform_called.should == true
  end
end

class FakeForm
  def form
    self
  end

  def controller
    @controller ||= FakeControllerClass.new
  end
end

class FakeControllerClass
  attr_accessor :pop_subform_called
  def pop_subform
    self.pop_subform_called = true
  end
end