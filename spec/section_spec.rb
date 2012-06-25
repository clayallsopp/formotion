describe "Sections" do
  it "section title setter works" do
    section = Formotion::Section.new
    section.title = "HELLO"
    section.title.should == "HELLO"
  end

  it "from hash should work" do
    hash = {title: "TITLE", rows: [{
      title: "FIRST TITLE"
    }, {
      title: "SECOND TITLE"
    }]}
    f = Formotion::Section.new(hash)
    f.title.should == "TITLE"
    f.rows.count.should == 2
    f.rows[0].title.should == "FIRST TITLE"
    f.rows[1].title.should == "SECOND TITLE"
  end
end