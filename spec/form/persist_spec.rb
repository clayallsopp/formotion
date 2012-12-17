describe "Form Persisting" do

  it "works" do
    key = "test_#{rand(255)}"
    App::Persistence["FORMOTION_#{key}"] = nil
    App::Persistence["FORMOTION_#{key}_ORIGINAL"] = nil
    f = Formotion::Form.persist({
      persist_as: key,
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
    saved.sections[0].rows[0].value.should == r.value

    f.reset
    r.value.should == "initial value"
  end

  it "works with subforms" do
    key = "test_#{rand(255)}"
    App::Persistence["FORMOTION_#{key}"] = nil
    App::Persistence["FORMOTION_#{key}_ORIGINAL"] = nil
    hash = {
      persist_as: key,
      sections: [
        rows: [ {
            key: :subform,
            type: :subform,
            title: "Subform",
            subform: {
              title: "New Page",
              sections: [
                rows: [{
                  key: "second",
                  type: "string",
                  value: "initial value"
                }]
              ]
            }
          }
        ]
      ]
    }
    f = Formotion::Form.persist(hash)
    f.to_hash.should == hash

    r = f.sections[0].rows[0].subform.to_form.sections[0].rows[0]
    r.value = "new value"

    saved = Formotion::Form.new(f.send(:load_state))
    saved.sections[0].rows[0].subform.to_form.sections[0].rows[0].value.should == r.value

    f.reset
    r.value.should == "initial value"
  end
end