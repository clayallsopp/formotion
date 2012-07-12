describe "Date Row" do
  before do
    row_settings = {
      title: "Date",
      key: :date,
      type: :date,
    }
    @row = Formotion::Row.new(row_settings)
    @row.reuse_identifier = 'test'
  end

  it "should initialize with correct settings" do
    @row.object.class.should == Formotion::RowType::DateRow
  end

  # Value
  it "should have no value by default" do
    cell = @row.make_cell

    @row.text_field.text.should == nil
  end

  it "should use custom value" do
    @row.value = 946684672
    cell = @row.make_cell
    @row.object.formatter.timeZone = NSTimeZone.timeZoneWithName "Europe/Paris"


    @row.text_field.text.should == '1/1/00'
  end

  # Picker
  it "should build date picker" do
    @row.object.picker.class.should == UIDatePicker
  end

  it "should update value when date is picked" do
    cell = @row.make_cell
    @row.object.formatter.timeZone = NSTimeZone.timeZoneWithName "Europe/Paris"

    @row.object.picker.date = NSDate.dateWithTimeIntervalSince1970(946684672)
    @row.object.picker.trigger UIControlEventValueChanged

    @row.value.should == 946684672
    @row.text_field.text.should == '1/1/00'
  end

  # Formats
  {
    :short => '1/1/00',
    :medium => 'Jan 1, 2000',
    :long => 'January 1, 2000',
    :full => 'Saturday, January 1, 2000'
  }.each do |format, expected_output|

    it "should display date in full format" do
      @row.value = 946684672
      @row.format = format
      cell = @row.make_cell
      @row.object.formatter.timeZone = NSTimeZone.timeZoneWithName "Europe/Paris"

      @row.text_field.text.should == expected_output
    end
  end




end