class FormableTestModel
  def self.the_transform
    @transform ||= lambda { |value| value.to_i + 10 }
  end

  include Formotion::Formable

  attr_accessor :my_name, :my_number

  form_property :my_name, :string, title: "My Name"
  form_property :my_number, :number, title: "My Number", :transform => the_transform

  form_title "Custom Title"

  def on_submit
    @submitted = true
  end
end

describe "Formotion::Formable" do
  it "form_properties should have correct structure" do
    FormableTestModel.form_properties.should == [{
        property: :my_name, row_type: :string, title: "My Name"
      }, {
        property: :my_number, row_type: :number, title: "My Number", :transform => FormableTestModel.the_transform
      }]
  end

  it "should set form_title" do
    FormableTestModel.form_title.should == "Custom Title"
  end

  describe ".to_form" do
    it "should have correct values" do
      comparison_form = Formotion::Form.new({
          title: "Custom Title",
          sections: [{
            rows: [{
                title: "My Name",
                key: :my_name,
                type: :string,
                value: nil
              }, {
                title: "My Number",
                key: :my_number,
                type: :number,
                value: nil
            }]
          }]
        })

      model = FormableTestModel.new
      model.to_form.to_hash.should == comparison_form.to_hash

      model.my_name = "Clay"
      model.my_number = 123

      comparison_form = Formotion::Form.new({
          title: "Custom Title",
          sections: [{
            rows: [{
                title: "My Name",
                key: :my_name,
                type: :string,
                value: "Clay"
              }, {
                title: "My Number",
                key: :my_number,
                type: :number,
                value: 123
            }]
          }]
        })

      model.to_form.to_hash.should == comparison_form.to_hash
    end

    it "should have transformed render values" do
      comparison_render = {
        my_name: "Clay",
        my_number: 133
      }

      model = FormableTestModel.new
      model.my_name = "Clay"
      model.my_number = 113

      form = model.to_form
      form.sections[0].rows[1].value = 123

      form.render.should == comparison_render
    end

    it "should have correct submit" do
      model = FormableTestModel.new
      model.to_form.submit
      model.instance_variable_get("@submitted").should == true
    end
  end
end