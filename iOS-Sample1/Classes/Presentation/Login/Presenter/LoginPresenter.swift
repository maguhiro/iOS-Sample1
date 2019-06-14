import Foundation

protocol LoginView: AnyObject {
  func showFullScreenLoading()
  func hideFullScreenLoading()
  func showAlert(title: String, handler: (() -> Void)?)
}

final class LoginPresenter {
  private let usecase = AuthenticationUseCase(accountRepository: MockAccountRepositoryImpl())
  var view: LoginView?

  func tapLogInButton(email: String, password: String) {
    view?.showFullScreenLoading()

    usecase.authenticate(email: email, password: password) { [weak self] result in
      self?.view?.hideFullScreenLoading()
      switch result {
      case .success:
        self?.view?.showAlert(title: "Succeeded to authenticate.") {
          log.d("tap alert!")
        }
      case .failure:
        self?.view?.showAlert(title: "Failed to authenticate.", handler: nil)
      }
    }
  }
}
