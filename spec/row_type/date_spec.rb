MILLENIUM = 946684672
TIME_ZONE = NSTimeZone.timeZoneWithName "Europe/Paris"

describe "Date Row" do
  tests_row :date do |row|
    row.object.formatter.timeZone = TIME_ZONE
    row.object.picker.timeZone = TIME_ZONE
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
    @row.value = MILLENIUM
    cell = @row.make_cell


    @row.text_field.text.should == '1/1/00'
  end

  # Picker
  it "should build date picker" do
    @row.object.picker.class.should == UIDatePicker
  end

  it "should update value when date is picked" do
    cell = @row.make_cell

    @row.object.picker.date = NSDate.dateWithTimeIntervalSince1970(MILLENIUM)
    @row.object.picker.trigger UIControlEventValueChanged

    @row.value.should == MILLENIUM
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
      @row.value = MILLENIUM
      @row.format = format
      @row.object.instance_variable_set("@formatter", nil)
      @row.object.formatter.timeZone = TIME_ZONE
      cell = @row.make_cell

      @row.text_field.text.should == expected_output
    end
  end

  # Modes
  {
    :date => '1/1/00',
    :time => '12:57 AM',
    :date_time => '1/1/00, 12:57 AM',
    :countdown => '00:57'
  }.each do |mode, expected_output|

    it "should display chosen mode #{mode} date/time format #{expected_output}" do
      @row.format = :short
      @row.picker_mode = mode
      cell = @row.make_cell
      @row.object.picker.date = NSDate.dateWithTimeIntervalSince1970(MILLENIUM)
      @row.object.picker.trigger UIControlEventValueChanged

      @row.text_field.text.should == expected_output
    end
  end

end
