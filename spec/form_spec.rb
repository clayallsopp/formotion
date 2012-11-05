describe "Forms" do
  it "assigning invalid sections doesnt work" do
    f = Formotion::Form.new

    should.not.raise(Formotion::InvalidClassError) {
      f.sections = [
        Formotion::Section.new
      ]
    }

    should.raise(Formotion::InvalidClassError) {
      f.sections = [
        "Hello"
      ]
    }
  end

  it "archiving works" do
    f = Formotion::Form.new
    section = f.build_section do |section|
      section.title = "HELLO"

      section.build_row do |row|
        row.title = "Label"
        row.subtitle = "Placeholder"
      end
    end

    result = NSKeyedUnarchiver.unarchiveObjectWithData(NSKeyedArchiver.archivedDataWithRootObject(f))

    result.sections.count.should == 1
    result.sections[0].title.should == "HELLO"
    result.sections[0].rows.count.should == 1
    result.sections[0].rows[0].title.should == "Label"
  end

  it "section builder works" do
    f = Formotion::Form.new
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

  it "render works correctly" do
    @form = Formotion::Form.new(sections: [{
     rows: [{
       key: :email,
       type: :email,
       editable: true,
       title: 'Email'
     }]}])

    row = @form.sections[0].rows[0]
    row.value = 'something@email.com'

    @form.render[:email].should == 'something@email.com'
  end

  it "fills out form values correctly" do
    @form = Formotion::Form.new(sections: [{
     rows: [{
       key: :email,
       type: :email,
       editable: true,
       title: 'Email'
     }]}])

    @form.values = { :email => 'something@email.com' }

    row = @form.sections[0].rows[0]
    row.value.should == 'something@email.com'
  end

  it "fills out form values correctly with a select one" do
    @form = Formotion::Form.new(sections: [{
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

    @form.values = { :b => true }

    row = @form.sections[0].rows[0]
    row.value.should == nil
    row = @form.sections[0].rows[1]
    row.value.should == true
    row = @form.sections[0].rows[2]
    row.value.should == nil
  end

  it "fills out form values correctly with a template" do
    @form = Formotion::Form.new(sections: [
    {
      title: 'Your nicknames',
      rows: [{
        title: "Add nickname",
        key: :nicknames,
        type: :template,
        template: {
          title: 'Nickname',
          type: :string,
          placeholder: 'Enter here',
          indented: true,
          deletable: true
        }
      }]
    }])


    @form.values = { :nicknames => ["Nici", "Sam"] }

    row = @form.sections[0].rows[0]
    row.value.should == ["Nici", "Sam"]
  end

  it "render with subforms works correctly" do
    @form = Formotion::Form.new(sections: [{
     rows: [{
       type: :subform,
       key: :subform,
       subform: {
          sections: [{
            rows: [{
              key: :email,
              type: :email,
              editable: true,
              title: 'Email'
            }]
          }]
       }
     }]}])

    subform = @form.sections[0].rows[0].subform.to_form
    row = subform.sections[0].rows[0]
    row.value = 'something@email.com'

    @form.render[:subform][:email].should == 'something@email.com'
  end

  it "fills out subform values correctly" do
   @form = Formotion::Form.new(sections: [{
     rows: [{
       type: :subform,
       key: :subform,
       subform: {
          sections: [{
            rows: [{
              key: :email,
              type: :email,
              editable: true,
              title: 'Email'
            }]
          }]
       }
     }]}])

    @form.values = { :email => 'something@email.com' }

    subform = @form.sections[0].rows[0].subform.to_form
    row = subform.sections[0].rows[0]
    row.value.should == 'something@email.com'
  end

  it "hashifying should be same as input" do
    h = {
      sections: [{
        title: "Login",
        rows: [{
          title: "Email",
          placeholder: "me@mail.com",
          type: :email,
          auto_correction:  UITextAutocorrectionTypeNo,
          auto_capitalization: UITextAutocapitalizationTypeNone
        }, {
          title: "Password",
          placeholder: "required",
          type: :string,
          secure: true
        }, {
          title: "Remember me?",
        }, {
          title: "Check me?",
        }]
      }, {
        title: "Options",
        select_one: true,
        rows: [{
          title: "Check me?",
        }, {
          title: "Check me 2?",
        }, {
          title: "Check me 3?",
        }]
      }]
    }
    form = Formotion::Form.new(h)

    form.to_hash.should == h
  end
end
