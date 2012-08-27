class TestModel
  include Formotion::Formable

  attr_accessor :my_name, :my_number

  form_property :my_name, :string, title: "My Name"
  form_property :my_number, :number, title: "My Number", :transform => lambda { |value| value.to_i + 10 }
end

class AdditionalTestModel
  include Formotion::Formable

  attr_accessor :my_other_name, :my_other_number

  form_property :my_other_name, :string
  form_property :my_other_number, :number
end

describe "FormableController" do
  tests Formotion::FormableController

  def controller
    @model ||= TestModel.new

    @controller ||= Formotion::FormableController.alloc.initWithModel(@model)
  end

  def string_row
    @controller.form.sections.first.rows.first
  end

  def number_row
    @controller.form.sections.first.rows.last
  end

  after do
    (@active_row || string_row).text_field.resignFirstResponder
    wait 1 do
      @active_row = nil
    end
  end

  it "should have new my_value after typing" do
    @active_row = string_row
    tap("My Name")
    string_row.text_field.setText("Hello")
    @model.my_name.should == "Hello"
  end

  it "should have new my_number after typing" do
    @active_row = number_row
    tap("My Number")
    number_row.text_field.setText("10")
    @model.my_number.should == 20
  end
end