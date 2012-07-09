describe "Image Row" do
  before do
    row_settings = {
      title: "Photo",
      key: :photo,
      type: :image
    }
    @row = Formotion::Row.new(row_settings)
    @row.reuse_identifier = 'test'


    @row.instance_eval do
      def form
        @form ||= Object.new.tap do |o|
          def o.reload_data
            # do nothing for tests
          end
        end
      end
    end
  end

  it "should build cell with an image view" do
    cell = @row.make_cell
    image_view = cell.viewWithTag(Formotion::RowType::ImageRow::IMAGE_VIEW_TAG)
    image_view.nil?.should == false
    image_view.class.should == UIImageView
    image_view.image.nil?.should == true
    cell.accessoryView.class.should == UIButton
  end

  # Value
  it "should change row properties when row gets a value" do
    cell = @row.make_cell

    @row.value = UIImage.alloc.init

    @row.rowHeight.should > 44
    image_view = cell.viewWithTag(Formotion::RowType::ImageRow::IMAGE_VIEW_TAG)
    image_view.image.nil?.should == false
    cell.accessoryView.nil?.should == true
  end
end