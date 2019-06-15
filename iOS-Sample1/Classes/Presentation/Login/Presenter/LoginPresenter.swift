import Foundation

protocol LoginView: AnyObject {
  func showFullScreenLoading()
  func hideFullScreenLoading()
  func showErrorAlert(title: String)
  func showSucceededAuthenticateAlert(title: String)
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
        self?.view?.showSucceededAuthenticateAlert(title: "Succeeded to authenticate.")
      case .failure:
        self?.view?.showErrorAlert(title: "Failed to authenticate.")
      }
    }
  }
}
