import RxCocoa
import RxSwift
import UIKit

final class LoginViewController: UIViewController {
  @IBOutlet private var emailTextField: UITextField!
  @IBOutlet private var passwordTextField: UITextField!
  @IBOutlet private var loginButton: UIButton!

  private let disposeBag = DisposeBag()
  private lazy var presenter: LoginPresenter = {
    let presenter = LoginPresenter()
    presenter.view = self
    return presenter
  }()

  override func viewDidLoad() {
    super.viewDidLoad()
    setupBinding()
  }
}

// MARK: Viewのレイアウト

private extension LoginViewController {
  func setupBinding() {
    let emailObservable = emailTextField.rx.text.orEmpty.distinctUntilChanged()
    let passwordObservable = passwordTextField.rx.text.orEmpty.distinctUntilChanged()

    let tappableObservable = Observable
      .combineLatest(emailObservable, passwordObservable)
      .map { email, password -> Bool in
        log.i("\(email) : \(password)")
        return !email.isEmpty && !password.isEmpty
      }
      .publish()

    tappableObservable
      .bind(to: loginButton.rx.isEnabled)
      .disposed(by: disposeBag)

    tappableObservable
      .map { tappable -> UIColor in
        tappable ? UIColor.orange : UIColor.brown
      }
      .bind(to: loginButton.rx.backgroundColor)
      .disposed(by: disposeBag)

    tappableObservable
      .connect()
      .disposed(by: disposeBag)
  }
}

// MARK: ユーザーアクション

private extension LoginViewController {
  @IBAction func tapLoginButton(_: UIButton) {
    log.d("clicked Log In Button")
    presenter.tapLogInButton(email: emailTextField.text.orEmpty, password: passwordTextField.text.orEmpty)
  }
}

// MARK: Presenterからの通知

extension LoginViewController: LoginView {
  func showFullScreenLoading() {
    log.d("showFullScreenLoading")
  }

  func hideFullScreenLoading() {
    log.d("hideFullScreenLoading")
  }

  func showAlert(title: String, handler: (() -> Void)?) {
    log.d("showAlert : \(title)")
    handler?()
  }
}
