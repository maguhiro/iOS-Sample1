import RxCocoa
import RxSwift
import UIKit

final class LoginViewController: UIViewController {
  @IBOutlet private var emailTextField: UITextField!
  @IBOutlet private var passwordTextField: UITextField!
  @IBOutlet private var loginButton: UIButton!

  private let indicatorVC = IndicatorViewController()

  private let disposeBag = DisposeBag()
  private lazy var presenter: LoginPresenter = {
    let presenter = LoginPresenter()
    presenter.view = self
    return presenter
  }()

  override func viewDidLoad() {
    super.viewDidLoad()
    initializeLayout()
    setupBinding()
  }
}

// MARK: Viewのレイアウト

private extension LoginViewController {
  func initializeLayout() {
    emailTextField.delegate = self
    passwordTextField.delegate = self

    let tapGesture = UITapGestureRecognizer(target: self, action: #selector(closeKeyboard(_:)))
    view.addGestureRecognizer(tapGesture)
    view.isUserInteractionEnabled = true
  }

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

  @objc func closeKeyboard(_: UITapGestureRecognizer) {
    view.endEditing(true)
  }
}

extension LoginViewController: UITextFieldDelegate {
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    switch textField {
    case emailTextField:
      passwordTextField.becomeFirstResponder()
    default:
      textField.resignFirstResponder()
      if loginButton.isEnabled {
        tapLoginButton(loginButton)
      }
    }

    return true
  }
}

// MARK: Presenterからの通知

extension LoginViewController: LoginView {
  func showFullScreenLoading() {
    present(indicatorVC, animated: false)
  }

  func hideFullScreenLoading() {
    indicatorVC.dismiss(animated: false)
  }

  func showAlert(title: String, handler: (() -> Void)?) {
    log.d("showAlert : \(title)")
    handler?()
  }
}
