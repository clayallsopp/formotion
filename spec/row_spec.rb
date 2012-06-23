describe "Rows" do
  it "method_missing should work" do
    r = Formation::Row.new
    r.title = "LABEL"
    r.title.should == "LABEL"

    r.title = "LABEL2"
    r.title.should == "LABEL2"
  end

  it "from hash should work" do
    hash = {title: "TITLE", subtitle: "SUBTITLE"}
    r = Formation::Row.new(hash)
    r.title.should == "TITLE"
    r.subtitle.should == "SUBTITLE"
  end
end
