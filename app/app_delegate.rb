class AppDelegate
  def application(application, didFinishLaunchingWithOptions:launchOptions)
    resetIconBadge
    @window = UIWindow.alloc.initWithFrame(UIScreen.mainScreen.bounds)
    @rotary_wc = RotaryWheelController.alloc.initWithNibName(nil, bundle: nil)

    @window.rootViewController = @rotary_wc
    @window.makeKeyAndVisible
    true
  end

  private

  def resetIconBadge
    App.shared.setApplicationIconBadgeNumber(0)
  end
end
