class AppDelegate
  def application(application, didFinishLaunchingWithOptions:launchOptions)
    @window = UIWindow.alloc.initWithFrame(UIScreen.mainScreen.bounds)

    @navigation_controller = UINavigationController.alloc.initWithRootViewController(UsersController.alloc.initWithNibName(nil, bundle:nil))
    @window.rootViewController = @navigation_controller
    @window.makeKeyAndVisible

    true
  end
end
