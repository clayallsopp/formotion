describe "FormController/WebViewRow" do
  tests Formotion::FormController

  # By default, `tests` uses @controller.init
  # this isn't ideal for our case, so override.
  def controller
    row_settings = {
      title: "WebView",
      key: :web_view,
      type: :web_view,
      value: "<html><body><b class=\"test\">This is a Test</b></body></html>"
    }
    @form ||= Formotion::Form.new(
      sections: [{
        rows:[row_settings]
    }])

    @controller ||= Formotion::FormController.alloc.initWithForm(@form)
  end

  def webview_row
    @form.row(:web_view)
  end
  
  it "should display the html content" do
    content = ""
    wait 1 do
      0.upto(6) do |i|
        content = webview_row.object.stringByEvaluatingJavaScriptFromString("document.getElementsByClassName('test')[0].innerHTML;")
        break if content != ""
        sleep 1
      end
      content.should == "This is a Test"
    end
  end
  
  it "should load the google home page" do
    webview_row.value = "https://www.google.com"
    wait 1 do
      while webview_row.object.loading
        sleep 1
      end
      content = ""
      0.upto(6) do |i|
        content = webview_row.object.stringByEvaluatingJavaScriptFromString("document.body.innerHTML")
        break if content != ""
        sleep 1
      end
      content.index("google").should > 0
    end
  end



end