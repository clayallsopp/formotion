describe "FormController/ImageRow" do
  tests Formotion::FormController

  # By default, `tests` uses @controller.init
  # this isn't ideal for our case, so override.
  def controller
    row_settings = {
      title: "Photo",
      key: :photo,
      type: :image
    }
    @form ||= Formotion::Form.new(
      sections: [{
        rows:[row_settings]
    }])

    @controller ||= Formotion::FormController.alloc.initWithForm(@form)
  end

  def image_row
    @form.sections.first.rows.first
  end

  def action_sheet
    image_row.object.instance_variable_get("@action_sheet")
  end

  # Looks like view(label) doesn't scan the UIActionSheet properly, so we override it.
  def tap_action_sheet(label)
    choose = self.action_sheet.send(:_viewByName, label)
    tap(choose)
  end

  # if action_sheet exists, just cancel it immediately for the next test.
  after do
    action_sheet && action_sheet.dismissWithClickedButtonIndex(action_sheet.cancelButtonIndex, animated: false)
  end

  it "should open an action sheet when tapped" do
    tap("Photo")
    action_sheet.nil?.should == false
  end

  it "should open photo library when 'choose' tapped" do
    tap("Photo")

    tap_action_sheet("Choose")
    view("Photos").nil?.should == false
    tap("Cancel")
  end

  it "should have value after selecting photo" do
    tap("Photo")

    # Looks like view(label) doesn't scan the UIActionSheet properly, so we override it.
    tap_action_sheet("Choose")

    image_controller = controller.modalViewController.visibleViewController

    image = UIImage.alloc.init
    info = { UIImagePickerControllerMediaType => KUTTypeImage,
               UIImagePickerControllerOriginalImage => image,
               UIImagePickerControllerMediaURL => NSURL.alloc.init}
    image_row.object.instance_variable_get("@camera").imagePickerController(image_controller, didFinishPickingMediaWithInfo: info)

    image_row.value.should == image
    tap("Cancel")
  end

  it "should be able to delete value" do
    image = UIImage.alloc.init
    image_row.value = image
    image_row.row_height.should > 44

    tap("Photo")

    # Looks like view(label) doesn't scan the UIActionSheet properly, so we override it.
    tap_action_sheet("Delete")
    image_row.row_height.should == 44
    image_row.value.should == nil
  end
end