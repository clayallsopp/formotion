class AppDelegate
  def application(application, didFinishLaunchingWithOptions:launchOptions)
    @window = UIWindow.alloc.initWithFrame(UIScreen.mainScreen.bounds)

    @view_controller =AccountSettingsController.alloc.initController

    @view_controller.navigationItem.leftBarButtonItem = UIBarButtonItem.alloc.initWithTitle("Render", style: UIBarButtonItemStyleBordered, target:self, action:'reset_form')

    @view_controller.navigationItem.rightBarButtonItem = UIBarButtonItem.alloc.initWithTitle("Save", style: UIBarButtonItemStyleBordered, target:self, action:'submit')

    @navigation_controller = UINavigationController.alloc.initWithRootViewController(@view_controller)

    @window.rootViewController = @navigation_controller
    @window.makeKeyAndVisible

    true
  end

  def submit
    @view_controller.form.submit
  end

  def reset_form
    AccountSettingsController.set_api_url_and_key_from_saved_settings
  end
end
