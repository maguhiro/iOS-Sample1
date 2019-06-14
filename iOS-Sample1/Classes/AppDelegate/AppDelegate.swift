import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  var window: UIWindow?

  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    setRootViewController()
    return true
  }

  func applicationWillResignActive(_: UIApplication) {}

  func applicationDidEnterBackground(_: UIApplication) {}

  func applicationWillEnterForeground(_: UIApplication) {}

  func applicationDidBecomeActive(_: UIApplication) {}

  func applicationWillTerminate(_: UIApplication) {}
}

private extension AppDelegate {
  func setRootViewController() {
    window = UIWindow(frame: UIScreen.main.bounds)
    window?.rootViewController = LoginViewController()
    window?.makeKeyAndVisible()
  }
}
