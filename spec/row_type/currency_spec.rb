describe "Number Row" do
  tests_row :currency

  def set_formatter_locale(locale)
    formatter = NSNumberFormatter.alloc.init
    formatter.numberStyle = NSNumberFormatterCurrencyStyle
    formatter.locale = NSLocale.alloc.initWithLocaleIdentifier(locale)
    @row.object.instance_variable_set("@number_formatter", formatter)
  end

  it "should initialize with correct settings" do
    cell = @row.make_cell
    @row.object.class.should == Formotion::RowType::CurrencyRow
    set_formatter_locale("en_US")
    @row.value.should == 0.0
    @row.object.row_value.should == "$0.00"
    @row.value_for_save_hash.should == 0.0
  end

  it "should work when row#value is changed" do
    cell = @row.make_cell
    set_formatter_locale("en_US")
    @row.value = 4.35
    @row.text_field.text.should == "$4.35"
  end

  it "should work when text_field#text is changed" do
    cell = @row.make_cell
    set_formatter_locale("en_US")
    @row.text_field.setText("$100.45")
    @row.text_field.delegate.on_change(@row.text_field)
    @row.value.should == 100.45
  end

  it "should work with different locale" do
    cell = @row.make_cell
    set_formatter_locale("it_IT")
    @row.value = 3004.35
    @row.text_field.text.should.start_with?("€")
    @row.text_field.text.should.end_with?("3.004,35")
  end

  it "should work with different locale and setting text_field#text" do
    cell = @row.make_cell
    set_formatter_locale("it_IT")
    @row.text_field.setText("€ 3.100,35")
    @row.text_field.delegate.on_change(@row.text_field)
    @row.value.should == 3100.35
  end
end