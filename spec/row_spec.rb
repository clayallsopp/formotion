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
    r.image.should == nil
  end

  it "should sent an image on the cell with a String" do
    hash = {title: "TITLE", subtitle: "SUBTITLE", image: "tags_row", type: :object, section: Formotion::Section.new({index: 0})}
    r = Formotion::Row.new(hash)
    r.index = 0
    cell = r.make_cell

    r.image.should == "tags_row"
    cell.imageView.image.should.not == nil
  end

  it "should sent an image on the cell with a UIImage" do
    image = UIImage.imageNamed("tags_row")
    hash = {title: "TITLE", subtitle: "SUBTITLE", image: image, type: :object, section: Formotion::Section.new({index: 0})}
    r = Formotion::Row.new(hash)
    r.index = 0
    cell = r.make_cell

    r.image.should == image
    cell.imageView.image.should == image
  end

  it "the question mark methods should work" do
    r = Formotion::Row.new({secure: true, title: "Not Boolean"})
    r.secure?.should == true
    should.raise(NoMethodError) {
      r.title?.should == true
    }
  end

  it "should allow arrays and blocks for items" do
    r = Formotion::Row.new()
    r.items = [1, 2, 3]
    r.items.should == [1, 2, 3]

    r.items = lambda { [1, 2, 3].reverse }
    r.items.should == [3, 2, 1]
  end
end
