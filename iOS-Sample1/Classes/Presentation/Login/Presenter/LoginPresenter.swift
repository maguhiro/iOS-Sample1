import Foundation

protocol LoginView: AnyObject {
  func showFullScreenLoading()
  func hideFullScreenLoading()
  func showAlert(title: String, handler: (() -> Void)?)
}

final class LoginPresenter {
  var view: LoginView?

  func tapLogInButton(email: String, password: String) {
    view?.showFullScreenLoading()

    sleep(3)

    view?.hideFullScreenLoading()
    view?.showAlert(title: "Succeeded to authenticate.") {
      log.d("tap alert!")
    }
  }
}
