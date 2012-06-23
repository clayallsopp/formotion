class AppDelegate
  def application(application, didFinishLaunchingWithOptions:launchOptions)
    @window = UIWindow.alloc.initWithFrame(UIScreen.mainScreen.bounds)

    form = Formation::Form.new({
      sections: [{
        title: "Register",
        rows: [{
          title: "Email",
          placeholder: "me@mail.com",
          type: Formation::RowType::EMAIL,
          editable: true,
          auto_correction:  UITextAutocorrectionTypeNo,
          auto_capitalization: UITextAutocapitalizationTypeNone
        }, {
          title: "Password",
          placeholder: "required",
          type: Formation::RowType::STRING,
          editable: true,
          secure: true
        }, {
          title: "Confirm",
          placeholder: "required",
          type: Formation::RowType::STRING,
          editable: true,
          secure: true
        }]
      }, {
        select_one: true,
        rows: [{
          title: "Remember?",
          switchable: true,
        }]
      }, {
        title: "Account Type",
        select_one: true,
        rows: [{
          title: "Free",
          checkable: true,
        }, {
          title: "Basic",
          checkable: true,
        }, {
          title: "Pro",
          checkable: true,
        }]
      }]
    })

    @view_controller = Formation::Controller.alloc.initWithForm(form)
    @window.rootViewController = @view_controller
    @window.makeKeyAndVisible
    true
  end
end
