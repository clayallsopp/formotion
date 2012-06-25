describe "Rows" do
  it "method_missing should work" do
    r = Formotion::Row.new
    r.title = "LABEL"
    r.title.should == "LABEL"

    r.title = "LABEL2"
    r.title.should == "LABEL2"
  end

  it "from hash should work" do
    hash = {title: "TITLE", subtitle: "SUBTITLE"}
    r = Formotion::Row.new(hash)
    r.title.should == "TITLE"
    r.subtitle.should == "SUBTITLE"
  end

  it "the question mark methods should work" do
    r = Formotion::Row.new({secure: true, title: "Not Boolean"})
    r.secure?.should == true
    should.raise(NoMethodError) {
      r.title?.should == true
    }
  end
end