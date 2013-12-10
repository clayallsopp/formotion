describe "FormController/WebLinkRow" do
  tests Formotion::FormController

  # By default, `tests` uses @controller.init
  # this isn't ideal for our case, so override.
  def controller
    row_settings = {
      title: "WebLink",
      key: :web_link,
      type: :web_link,
      value: "http://www.rubymotion.com"
    }
    @form ||= Formotion::Form.new(
      sections: [{
        rows:[row_settings]
    }])

    @controller ||= Formotion::FormController.alloc.initWithForm(@form)
  end

  def weblink_row
    @form.row(:web_link)
  end

  it "should accept a string" do
    weblink_row.value.should == "http://www.rubymotion.com"
  end

  it "should accept a NSURL" do
    weblink_row.value = NSURL.URLWithString("http://www.rubymotion.com")
    weblink_row.value.is_a?(NSURL).should == true
    weblink_row.value.absoluteString.should == "http://www.rubymotion.com"
  end

end
