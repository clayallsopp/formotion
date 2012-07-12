describe "FormController/CheckRow" do
  tests Formotion::FormController

  # By default, `tests` uses @controller.init
  # this isn't ideal for our case, so override.
  def controller
    @form ||= Formotion::Form.new(
      sections: [{
        title: "Select One",
        key: :account_type,
        select_one: true,
        rows: [{
          title: "A",
          key: :a,
          type: :check,
          value: true
        }, {
          title: "B",
          key: :b,
          type: :check,
        }, {
          title: "C",
          key: :c,
          type: :check,
        }]
    }])

    @controller ||= Formotion::FormController.alloc.initWithForm(@form)
  end

  it "should leave only one row checked" do
    rows = ["A", "B", "C"]
    rows.each_with_index {|letter, i|
      tap letter
      @form.sections[0].rows.each_with_index {|row, index|
        (!!(row.value)).should == (index == i)
      }
      wait 1 do
      end
    }
  end
end