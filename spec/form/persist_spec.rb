describe "Form Persisting" do
  it "works" do
    f = Formotion::Form.persist({
      persist_as: "test",
      sections: [
        rows: [ {
            key: "first",
            type: "string",
            value: "initial value"
          }
        ]
      ]
    })

    r = f.sections[0].rows[0]
    r.value = "new value"

    saved = Formotion::Form.new(f.send(:load_state))
    saved.value.should == r.value

    f.reset
    r.value.should == "initial value"

  end
end