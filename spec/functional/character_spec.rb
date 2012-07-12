describe "FormController/StringRow" do
  tests Formotion::FormController

  def controller
    make_row_settings = lambda { |index|
      {
        title: "String#{index == 0 ? '' : ' ' + index.to_s}",
        key: :string,
        type: :string
      }
    }
    @form ||= Formotion::Form.new(
      sections: [{
        rows:(0..20).collect {|i|
          make_row_settings.call(i)
        }
    }])

    @controller ||= Formotion::FormController.alloc.initWithForm(@form)
  end

  def string_row
    @form.sections.first.rows.first
  end

  after do
    (@active_row || string_row).text_field.resignFirstResponder
    wait 1 do
      @active_row = nil
    end
  end

  it "should pop open the keyboard when tapped" do
    @notif = App.notification_center.observe UIKeyboardDidShowNotification do |notification|
      @did_show = true
    end
    tap("String")
    # wait for keyboard to actually pop up
    wait 1 do
      @did_show.should == true
      App.notification_center.unobserve @notif
    end
  end

  it "should have new value after typing" do
    tap("String")
    string_row.text_field.setText("Hello")
    string_row.text_field.resignFirstResponder
    string_row.value.should == "Hello"
  end

  it "should scroll to correct offset when tapping" do
    @notif = App.notification_center.observe UIKeyboardDidShowNotification do |notification|
      @key_rect = notification.userInfo[UIKeyboardFrameBeginUserInfoKey].CGRectValue
    end

    tap("String 9")
    wait 1 do
      table_view = self.controller.tableView
      index_path = NSIndexPath.indexPathForRow(9, inSection: 0)
      row_rect = table_view.convertRect(table_view.rectForRowAtIndexPath(index_path), toView: nil)

      bottom_y = row_rect.origin.y + row_rect.size.height
      bottom_y.should == @key_rect.origin.y - @key_rect.size.height
      App.notification_center.unobserve @notif
      @key_rect = nil
      @active_row = @form.sections.first.rows[9]
    end
  end
end