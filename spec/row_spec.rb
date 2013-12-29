describe "Rows" do

  before do
    @image_name = "tags_row"
    @image = UIImage.imageNamed(@image_name)
    string_hash = {title: "TITLE", subtitle: "SUBTITLE", image: @image_name, type: :object, section: Formotion::Section.new({index: 0})}
    image_hash = string_hash.merge({image: @image})
    @string_image_row = Formotion::Row.new(string_hash)
    @string_image_row.index = 0

    @image_row = Formotion::Row.new(image_hash)
    @image_row.index = 0
  end

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

  it "should set an image on the cell with a String" do
    @string_image_row.image.should == @image_name

    cell = @string_image_row.make_cell
    cell.imageView.image.should.not == nil
  end

  it "should set an image on the cell with a UIImage" do
    @image_row.image.should == @image

    cell = @image_row.make_cell
    cell.imageView.image.should == @image
  end

  it "should change the image after cell creation" do
    @image_row.image.should == @image

    cell = @image_row.make_cell
    cell.imageView.image.should == @image

    new_image = UIImage.imageNamed("camera")
    @image_row.image = new_image

    cell.imageView.image.should.not == @image
    cell.imageView.image.should == new_image
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
