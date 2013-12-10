describe "Web Link Row" do
  tests_row :web_link

  before do
    @link_url = "http://www.rubymotion.com"
  end

  it "should initialize with correct settings" do
    @row.object.class.should == Formotion::RowType::WebLinkRow
  end

  it "should have a cell indicator" do
    cell = @row.make_cell
    cell.accessoryType.should == UITableViewCellAccessoryDisclosureIndicator
  end

  it "should accept a string value" do
    @row.value = @link_url
    cell = @row.make_cell
    @row.value.is_a?(String).should == true
  end

end
