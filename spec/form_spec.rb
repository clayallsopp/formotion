describe "Forms" do
  it "section title setter works" do
    section = Formation::Section.new
    section.title = "HELLO"
    section.title.should == "HELLO"
  end

  it "archiving works" do
    f = Formation::Form.new
    section = f.build_section do |section|
      section.title = "HELLO"

      section.build_row do |row|
        row.title = "Label"
        row.subtitle = "Placeholder"
      end
    end

    result = NSKeyedUnarchiver.unarchiveObjectWithData(NSKeyedArchiver.archivedDataWithRootObject(f))
    result.should == f
  end

  it "section builder works" do
    f = Formation::Form.new
    section = f.build_section do |section|
      section.title = "HELLO"

      section.build_row do |row|
        row.title = "Label"
        row.subtitle = "Placeholder"
      end
    end

    section.title.should == "HELLO"
    section.rows.count.should == 1

    row = section.rows[0]
    row.title.should == "Label"
    row.subtitle.should == "Placeholder"
  end

  it "json should be good" do
    h = {
      sections: [{
        title: "Login",
        rows: [{
          title: "Email",
          placeholder: "me@mail.com",
          type: Formation::RowType::EMAIL,
          editable: true,
          auto_correction:  UITextAutocorrectionTypeNo,
          auto_capitalization: UITextAutocapitalizationTypeNone
        }, {
          title: "Password",
          placeholder: "required",
          type: Formation::RowType::STRING,
          editable: true,
          secure: true
        }, {
          title: "Remember me?",
          switchable: true,
        }, {
          title: "Check me?",
          checkable: true,
        }]
      }, {
        title: "Options",
        select_one: true,
        rows: [{
          title: "Check me?",
          checkable: true,
        }, {
          title: "Check me 2?",
          checkable: true,
        }, {
          title: "Check me 3?",
          checkable: true,
        }]
      }]
    }
    form = Formation::Form.new(h)

    form.to_hash.should == h
  end
end
