describe "Sections" do
  it "from hash should work" do
    hash = {title: "TITLE", rows: [{
      title: "FIRST TITLE"
    }, {
      title: "SECOND TITLE"
    }]}
    f = Formation::Section.new(hash)
    f.title.should == "TITLE"
    f.rows.count.should == 2
    f.rows[0].title.should == "FIRST TITLE"
    f.rows[1].title.should == "SECOND TITLE"
  end
end