describe "FormController/ActivityRow" do
  tests Formotion::FormController

  # By default, `tests` uses @controller.init
  # this isn't ideal for our case, so override.
  def controller
    row_settings = {
      title: "Activity View",
      key: :activity,
      type: :activity,
      value: "Share the joys of Rubymotion! http://www.rubymotion.com"
    }
    @form ||= Formotion::Form.new(
      sections: [{
        rows:[row_settings]
    }])

    @controller ||= Formotion::FormController.alloc.initWithForm(@form)
  end

  def activity_row
    @form.row(:activity)
  end

  it "should initialize with correct settings" do
    activity_row.object.class.should == Formotion::RowType::ActivityRow
  end

  it "should initialize with defaults" do
    activity_row.value[:excluded].should == []
    activity_row.value[:animated].should == true
    activity_row.value[:app_activities].should == nil
    activity_row.value[:completion].should == nil
  end

  it "should have an array as the items" do
    activity_row.value[:items].is_a?(Array).should == true
  end
end

describe "FormController/ActivityRow Hash" do
  tests Formotion::FormController

  # By default, `tests` uses @controller.init
  # this isn't ideal for our case, so override.
  def controller
    row_settings = {
      title: "Activity View",
      key: :activity,
      type: :activity,
      value: {
        items: "Share the joys of Rubymotion! http://www.rubymotion.com"
      }
    }
    @form ||= Formotion::Form.new(
      sections: [{
        rows:[row_settings]
    }])

    @controller ||= Formotion::FormController.alloc.initWithForm(@form)
  end

  def activity_row
    @form.row(:activity)
  end

  it "should turn the items string into an array" do
    activity_row.value[:items].is_a?(Array).should == true
  end
end

describe "FormController/ActivityRow Exclusions" do
  tests Formotion::FormController

  # By default, `tests` uses @controller.init
  # this isn't ideal for our case, so override.
  def controller
    row_settings = {
      title: "Activity View",
      key: :activity,
      type: :activity,
      value: {
        items: "Share the joys of Rubymotion! http://www.rubymotion.com",
        excluded: [
          UIActivityTypeAddToReadingList,
          UIActivityTypeAirDrop,
          UIActivityTypeCopyToPasteboard,
          UIActivityTypePrint
        ]
      }
    }
    @form ||= Formotion::Form.new(
      sections: [{
        rows:[row_settings]
    }])

    @controller ||= Formotion::FormController.alloc.initWithForm(@form)
  end

  def activity_row
    @form.row(:activity)
  end

  it "should exclude certain activity types" do
    activity_row.value[:excluded].is_a?(Array).should == true
    activity_row.value[:excluded].count.should == 4
    activity_row.value[:excluded][0].should == UIActivityTypeAddToReadingList
  end
end

describe "FormController/ActivityRow MultipleItems" do
  tests Formotion::FormController

  # By default, `tests` uses @controller.init
  # this isn't ideal for our case, so override.
  def controller
    row_settings = {
      title: "Activity View",
      key: :activity,
      type: :activity,
      value: {
        items: ["Share the joys of Rubymotion! http://www.rubymotion.com", UIImage.imageNamed("tags_row-selected")],
        excluded: [
          UIActivityTypeAddToReadingList,
          UIActivityTypeAirDrop,
          UIActivityTypeCopyToPasteboard,
          UIActivityTypePrint
        ]
      }
    }
    @form ||= Formotion::Form.new(
      sections: [{
        rows:[row_settings]
    }])

    @controller ||= Formotion::FormController.alloc.initWithForm(@form)
  end

  def activity_row
    @form.row(:activity)
  end

  it "should allow sharing images" do
    activity_row.value[:items].first.is_a?(String).should == true
    activity_row.value[:items].last.is_a?(UIImage).should == true
  end
end
