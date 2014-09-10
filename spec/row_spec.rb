describe "Rows" do

  before do
    @image_name = "tags_row"
    @image = UIImage.imageNamed(@image_name)
    @remote_image_url = "http://lorempixel.com/80/80?t=#{Time.now.to_i}"
    @remote_placeholder_image_name = 'camera'
    @remote_placeholder_image = UIImage.imageNamed(@remote_placeholder_image_name)

    string_hash = {title: "TITLE", subtitle: "SUBTITLE", image: @image_name, type: :object, section: Formotion::Section.new({index: 0})}
    @string_image_row = Formotion::Row.new(string_hash)
    @string_image_row.index = 0

    image_hash = string_hash.merge({image: @image})
    @image_row = Formotion::Row.new(image_hash)
    @image_row.index = 0

    remote_image_hash = image_hash.merge({image: @remote_image_url})
    @remote_image_row = Formotion::Row.new(remote_image_hash)
    @remote_image_row.index = 0

    remote_placeholder_image_hash = remote_image_hash.merge({image_placeholder: @remote_placeholder_image})
    @remote_placeholder_image_row = Formotion::Row.new(remote_placeholder_image_hash)
    @remote_placeholder_image_row.index = 0
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

  it "should set an image on the cell using a remote URL" do

    @remote_image_row.image.should == @remote_image_url

    cell = @remote_image_row.make_cell

    wait 1 do
      cell.imageView.image.should != nil
      cell.imageView.image.is_a?(UIImage).should == true
    end

  end

  it "should set a remote image with a placeholder" do
    @remote_placeholder_image_row.image.should == @remote_image_url
    @remote_placeholder_image_row.image_placeholder.should == @remote_placeholder_image

    cell = @remote_placeholder_image_row.make_cell

    wait 1 do
      cell.imageView.image.size.should != @remote_placeholder_image.size
    end
  end

  it "should set a remote image after another image has already been set" do
    cell = @remote_placeholder_image_row.make_cell

    wait 1 do
      img = cell.imageView.image
      cell.imageView.image.size.should != @remote_placeholder_image.size

      @remote_placeholder_image_row.image = "http://lorempixel.com/80/80?t=#{Time.now.to_i}"
      wait 1 do
        cell.imageView.image.should != img
      end
    end

  end

  it "should set a local image after a remote image has already been set" do
    cell = @remote_placeholder_image_row.make_cell

    wait 1 do
      img = cell.imageView.image
      cell.imageView.image.size.should != @remote_placeholder_image.size

      new_image = UIImage.imageNamed("camera")
      @remote_placeholder_image_row.image = new_image

      cell.imageView.image.should.not == img
      cell.imageView.image.should == new_image
    end

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
